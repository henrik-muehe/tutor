class Room < ActiveRecord::Base
	has_and_belongs_to_many :exams

	def seat_count
		seats.split("\n").length
	end
end
