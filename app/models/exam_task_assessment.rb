class ExamTaskAssessment < ActiveRecord::Base
	belongs_to :exam_assessment
	belongs_to :exam_task

	validates :exam_task, presence: true
	validates :points, presence: { message: 'Task assessment is not a valid number of points.' }, numericality: { greater_than_or_equal_to: 0, less_than: 100, message: 'Task assessment is not a valid number of points.' }
end
