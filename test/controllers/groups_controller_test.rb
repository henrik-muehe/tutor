require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    sign_in :user, User.where(:email => 'admin@example.com').first
    @group = groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create, group: { course_id: @group.course_id, name: @group.name, start: @group.start, user_id: @group.user_id }
    end

    assert_redirected_to groups_path
  end

  test "should show group" do
    get :show, id: @group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @group
    assert_response :success
  end

  test "should update group" do
    patch :update, id: @group, group: { course_id: @group.course_id, name: @group.name, start: @group.start, user_id: @group.user_id }
    assert_redirected_to groups_path
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete :destroy, id: @group
    end

    assert_redirected_to groups_path
  end
end
