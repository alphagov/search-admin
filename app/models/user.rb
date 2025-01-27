class User < ApplicationRecord
  # GDS SSO key for administrative permissions
  ADMIN_PERMISSION_KEY = "admin".freeze

  include GDS::SSO::User

  serialize :permissions, type: Array

  def admin?
    permissions.include?(ADMIN_PERMISSION_KEY)
  end
end
