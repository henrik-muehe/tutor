require 'test_helper'

class LoadControllerTest < ActionController::TestCase
  test "should get tumonline" do
    get :tumonline
    assert_response :success
  end

  test "should get create_tumonline" do
    get :create_tumonline
    assert_response :success
  end

end
