module ControlsHelper
  # Returns the translated type name of a `Control`'s action.
  def t_control_action(control, count: 1)
    control.action.model_name.human(count:)
  end
end
