# Requires a user to be logged in through GDS SSO for any action.
module Authentication
  extend ActiveSupport::Concern

  included do
    include GDS::SSO::ControllerMethods

    before_action :authenticate_user!
  end
end
