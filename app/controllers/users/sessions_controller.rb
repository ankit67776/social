class Users::SessionsController < Devise::SessionsController
  protected

  # path after login
  def after_sign_in_path_for(resource)
    hello_path # redirect to the /hello after login
  end

  # path after logout
  def after_sign_out_path_for(resource_or_scope)
    root_path # redirect to the root path after logout
  end
end
