require 'csv'    

class Exam < ActiveRecord::Base
	belongs_to :course
	
	has_and_belongs_to_many :rooms
	accepts_nested_attributes_for :rooms

	has_many :exam_tasks
  	accepts_nested_attributes_for :exam_tasks, reject_if: :all_blank, allow_destroy: true

	has_many :exam_seats
	has_and_belongs_to_many :students

	def seats?
		exam_seats.length > 0
	end

	def graded?
		false
	end

	def original_import=(v)
		write_attribute(:original_import, File.read(v.path, :encoding => 'iso-8859-15'))

		self.start=nil
		self.students = []
		CSV.open(v.path, { 
			:encoding => 'iso-8859-15', 
			:headers => true,
			:col_sep => ';' 
		}).each do |row|
			self.start = DateTime.parse(row["DATE_OF_ASSESSMENT"]) 
			s = Student.find_or_create_by_matrnr(row["REGISTRATION_NUMBER"].to_i)
			s.update_attributes({ :lastname => row["FAMILY_NAME_OF_STUDENT"], :firstname => row["FIRST_NAME_OF_STUDENT"] })
			self.students << s
		end
	end

	def export(filename)
		# open original import
		orig = CSV.new(original_import, { 
			headers: true,
			write_headers: true,
			col_sep: ';' 
		})

		# build something alike for output
		CSV.open(filename, "w", 
			:encoding => 'iso-8859-15', 
			:headers => true,
			:write_headers => true, 
			:col_sep => ';',
			:force_quotes => true
		) do |csv|
			csv << orig.first.to_hash.keys
			orig.each do |p|
				p["REMARK"] = yield p["REGISTRATION_NUMBER"].to_i
				csv << p
			end
		end
	end

	def export_seats(filename)
		export(filename) do |matrnr|
			exam_seats.includes(:student).where("students.matrnr" => matrnr).first.seat_string
		end
	end
end
