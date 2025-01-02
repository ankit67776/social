# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!, only: [ :new, :create ]
  before_action :ensure_devise_mapping

  protected

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    Rails.logger.debug "after_sign_up_path_for called with resource: #{resource.inspect}"
    hello_path
  end

  private

  # Ensure Devise mapping is set correctly
  def ensure_devise_mapping
    Rails.logger.debug "ensure_devise_mapping called"
    request.env["devise.mapping"] = Devise.mappings[:user] # Use `request.env` instead of `@request.env`
  end

  # Set minimum password length if validatable is enabled
  def set_minimum_password_length
    if devise_mapping&.validatable?
      Rails.logger.debug "set_minimum_password_length called"
      @minimum_password_length = resource_class.password_length.min
    end
  end
end
