class ExamAssessment < ActiveRecord::Base
	belongs_to :exam
	has_many :exam_task_assessments
	belongs_to :student

	validates :exam, presence: true
	validate :task_assessments_equal_number_of_tasks

	def task_assessments_equal_number_of_tasks
		self.errors[:exam_task_assessments] << "Number of assessments must match number of tasks in exam (#{exam_task_assessments.length} vs. #{exam.exam_tasks.length})." if exam_task_assessments.length != exam.exam_tasks.length	
	end

	def assessment_string=(v)
		exam_task_assessments.destroy_all

		v.gsub!(/[\s\t\r\n]/, "")

		if v == "x" || v == "X" 
			status = :noshow
		elsif v == "0"
			exam.exam_tasks.each do |task|
				exam_task_assessments << ExamTaskAssessment.new({ :points => 0, :exam_task => task })
			end
			status = :attended
		else
			v.split("+").each_with_index do |g,i|
				et = exam.exam_tasks.where(:number => (i+1)).first
				points = g.to_f
				points = nil if not g.match(/^\d+[.,]?\d*$/)
				exam_task_assessments << ExamTaskAssessment.new({ :points => points, :exam_task => et })
			end
			status = :attended
		end
	end

	def assessment_string
		exam_task_assessments.includes(:exam_task).order("exam_tasks.number").map{|x|"%g" % x.points}.join("+")
	end

	def total
		exam_task_assessments.map{ |t| t.points }.reduce(:+)
	end
end
