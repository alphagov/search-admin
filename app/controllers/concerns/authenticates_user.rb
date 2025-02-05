# Enforces user authentication for a controller and stores the authenticated user in `Current`
module AuthenticatesUser
  extend ActiveSupport::Concern

  included do
    include GDS::SSO::ControllerMethods

    before_action do
      authenticate_user!

      Current.user = current_user
    end
  end
end
