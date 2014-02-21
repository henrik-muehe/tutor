class ExamTaskAssessment < ActiveRecord::Base
	belongs_to :exam_assessment
	belongs_to :exam_task

	validates :exam_task, presence: true
	validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
