# Provides more concise helper methods for translating model names and attributes, assuming that the
# current controller is named after the model it is managing.
module ModelTranslationHelper
  # Returns the translated model name for a given model or record, or if not provided, the model
  # corresponding to the current controller.
  def t_model_name(model_or_record = nil, count: 1)
    target = model_or_record || inferred_model_class
    target.model_name.human(count:)
  end

  # Returns the translated name for the given attribute on a given model or record, or if not
  # provided, the current controller's model.
  def t_model_attr(attr, on: nil)
    target = on&.class || inferred_model_class
    target.human_attribute_name(attr)
  end

private

  def inferred_model_class
    @inferred_model_class ||= controller.controller_name.classify.constantize
  end
end
