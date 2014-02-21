require 'test_helper'

class ExamTaskAssessmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "can not save without task" do
  	e = ExamAssessment.new
    t = ExamTaskAssessment.new({ :exam_assessment => e })
    assert (!t.save)
  end
end
