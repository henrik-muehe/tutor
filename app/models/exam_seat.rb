class ExamSeat < ActiveRecord::Base
	belongs_to :exam
	belongs_to :student
	belongs_to :room
end
