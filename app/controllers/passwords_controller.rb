class PasswordsController < Devise::PasswordsController
  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    "/users"
  end
  def after_resetting_password_path_for
  	"/tutorial"
  end
end
