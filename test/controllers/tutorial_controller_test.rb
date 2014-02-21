require 'test_helper'

class TutorialControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in :user, User.where(:email => 'test@example.com').first
    get :index
    assert_response :success
  end
end
