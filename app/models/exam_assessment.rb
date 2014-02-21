class ExamAssessment < ActiveRecord::Base
	belongs_to :exam
	has_many :exam_task_assessments

	validates :exam, presence: true
	validate :task_assessments_equal_number_of_tasks

	def task_assessments_equal_number_of_tasks
		self.errors[:exam_task_assessments] << "Number of assessments must match number of tasks in exam." if exam_task_assessments.length != exam.exam_tasks.length	
	end

	def assessment_string=(v)
		exam_task_assessments.destroy_all

		v.gsub!(/[\s\t\r\n]/, "")
		v.split("+").each_with_index do |g,i|
			et = exam.exam_tasks.where(:number => (i+1)).first
			exam_task_assessments << ExamTaskAssessment.new({ :points => g.to_i, :exam_task => et })
		end
	end

	def total
		exam_task_assessments.map{ |t| t.points }.reduce(:+)
	end
end
