class User < ApplicationRecord
  ADMIN_PERMISSION_KEY = "admin".freeze

  include GDS::SSO::User

  serialize :permissions, type: Array

  def admin?
    permissions.include?(ADMIN_PERMISSION_KEY)
  end
end
