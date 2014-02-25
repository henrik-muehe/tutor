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

	def roominfo
		nil if not seats?
		rooms.order(:name).map do |room|
			students = exam_seats.includes(:student).where("room_id = ? and student_id is not null", room.id)
					.to_a.sort_by { |seat|  ActiveSupport::Inflector.transliterate(seat.student.name) }
					.map { |seat| seat.student }
			{
				name: room.name,
				count: exam_seats.where(:room_id => room.id).count,
				first: ActiveSupport::Inflector.transliterate(students.first.name),
				last: ActiveSupport::Inflector.transliterate(students.last.name),
			}
		end
	end

	def prefix_length(a,b)
		minl = [a.length,b.length].min
		(0..minl-1).each do |i|
			return i if (a[i]!=b[i]) 
		end
		return minl
	end

	def roominfo_public
		info = roominfo
		last = nil
		clean = []
		info.each_with_index do |i,index|
			if last.nil? then
				i[:first] = "A"
			else
				l = prefix_length(i[:first], last[:last])
				last[:last] = last[:last][0,l+1]
				i[:first] = i[:first][0,l+1]
			end

			if index == info.length-1
				i[:last] = "Z"
			end 

			clean << i
			last=i
		end
		clean
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
			col_sep: ';' 
		})

		# build something alike for output
		first=true
		CSV.open(filename, "w", 
			:encoding => 'iso-8859-15', 
			:headers => false,
			:write_headers => false,
			:col_sep => ';',
			:force_quotes => true
		) do |csv|
			orig.each do |p|
				if first then
					csv << p.to_hash.keys
					first=false
				end
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
