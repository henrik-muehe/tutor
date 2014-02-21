require 'test_helper'

class ExamAssessmentTest < ActiveSupport::TestCase 
	setup do
		@exam = Exam.create({ :name => "x" })
		@exam.exam_tasks << ExamTask.create({number: 1, max_points: 10})
		@exam.exam_tasks << ExamTask.create({number: 2, max_points: 10})
		@exam.exam_tasks << ExamTask.create({number: 3, max_points: 10})
		ExamAssessment.destroy_all
		ExamTaskAssessment.destroy_all
		@eat = ExamAssessment.create({exam: @exam})
	end	

	test "string assignment works" do
		@eat.assessment_string = "5 +6+ 	1	"
		# test cardinality
		assert @eat.exam_task_assessments.length == 3

		# test actual points
		points = @eat.exam_task_assessments.map do |t| t.points end
		assert points.include? 5
		assert points.include? 6
		assert points.include? 1
		assert (!points.include? 3)
	end

	test "computes total" do
		@eat.assessment_string = "5 +6+ 	1	"
		assert @eat.total == 12
	end

	test "number of task assessments must match number of tasks" do
		@eat.assessment_string = "5 +6"
		assert !@eat.save, @eat.errors.to_yaml
	end

	test "old task assessments are reaped on assignment" do
		@eat.assessment_string = "5 +6+ 	1	"
		assert @eat.save, @eat.errors.to_yaml
		assert_difference("ExamTaskAssessment.count", 0) do
			@eat.assessment_string = "6 +7+ 	2	"
			assert @eat.save
		end
	end
end
