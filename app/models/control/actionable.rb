# Provides functionality for models acting as the `action` delegated type of `Control`, in
# particular their relationship back to the control.
module Control::Actionable
  extend ActiveSupport::Concern

  included do
    has_one :control, as: :action, touch: true, dependent: :destroy
  end

  # Allow rendering an action partial as just its unqualified name when using `render`, e.g.
  # `filter_action` instead of `control/filter_actions/filter_action`.
  def to_partial_path
    model_name.element
  end
end
