# Requires a user to be logged in through GDS SSO for any action, and keeps track of the current
# user through `Current`.
module Authentication
  extend ActiveSupport::Concern

  included do
    include GDS::SSO::ControllerMethods

    before_action :authenticate_user!, :set_current
  end

private

  def set_current
    Current.user = current_user
  end
end
