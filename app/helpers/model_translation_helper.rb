# Provides more concise helper methods for translating model names and attributes, assuming that the
# current controller is named after the model it is managing.
module ModelTranslationHelper
  # Returns the translated model name for the current controller.
  def t_model_name(count: 1)
    inferred_model_class.model_name.human(count:)
  end

  # Returns the translated name for the given attribute on the current controller's model.
  def t_model_attr(attr)
    inferred_model_class.human_attribute_name(attr)
  end

private

  def inferred_model_class
    @inferred_model_class ||= controller.controller_name.classify.constantize
  end
end
