module HumanModelTranslations
  extend ActiveSupport::Concern

  included do
    helper_method :human_record_name, :human_records_name, :human_attribute_name
  end

  private

  def human_record_name
    model_class.model_name.human
  end

  def human_records_name
    model_class.model_name.human.pluralize
  end

  def human_attribute_name(attribute)
    model_class.human_attribute_name(attribute)
  end

  def model_class
    @model_class ||= controller_name.classify.safe_constantize ||
      raise("Could not infer model from controller name '#{self.class.name}'")
  end
end
