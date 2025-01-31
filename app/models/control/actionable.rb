# Provides functionality for models acting as the `action` delegated type of `Control`, in
# particular their relationship back to the control.
module Control::Actionable
  extend ActiveSupport::Concern

  included do
    has_one :control, as: :action, touch: true, dependent: :destroy
  end
end
