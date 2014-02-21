require 'test_helper'

class LoadControllerTest < ActionController::TestCase
  setup do
    sign_in :user, User.where(:email => 'admin@example.com').first
  end

end
