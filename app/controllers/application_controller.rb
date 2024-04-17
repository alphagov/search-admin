class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include GDS::SSO::ControllerMethods
  before_action :authenticate_user!

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  def admin_user?
    current_user.permissions.include?("admin")
  end
end
