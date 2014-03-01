class ExamGrade < ActiveRecord::Base
  belongs_to :exam
  belongs_to :student
  belongs_to :exam_assessment
end
