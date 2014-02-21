require 'csv'    

class Exam < ActiveRecord::Base
	has_and_belongs_to_many :rooms
	accepts_nested_attributes_for :rooms
	has_many :exam_tasks
  	accepts_nested_attributes_for :exam_tasks, reject_if: :all_blank, allow_destroy: true
	has_many :exam_seats

	def seats?
		not seat_assignment.nil?
	end

	def graded?
		false
	end
	
	def participants
		parts = []
		CSV.new(original_import, { 
			:encoding => 'bom|utf-8', 
			:headers => true,
			:col_sep => ';' 
		}).each do |row|
			if not self.start
				self.start = DateTime.parse(row["DATE_OF_ASSESSMENT"]) 
				save
			end
			parts << row
		end
		parts
	end

	def export(filename,info)
		# tum online requires the format to be exactly this
		CSV.open(filename, "w", 
			:encoding => 'iso-8859-15', 
			:headers => true, 
			:col_sep => ';',
			:force_quotes => true
		) do |csv|
			csv << participants.first.to_hash.keys
			participants.each do |p|
				p["REMARK"] = info[p["REGISTRATION_NUMBER"].to_i.to_s]
				csv << p
			end
		end
	end

	def export_seats(filename)
		mapping = {}
	    seats = JSON.parse(seat_assignment)
	    seats.each do |r| mapping.merge! r["mapping"] end
	    	p mapping
	   	export(filename,mapping)
	end
end
