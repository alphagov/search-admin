# Stores cross-cutting concerns for every request
class Current < ActiveSupport::CurrentAttributes
  attribute :user

  def user?
    user.present?
  end
end
