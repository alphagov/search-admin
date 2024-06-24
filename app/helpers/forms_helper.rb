module FormsHelper
  def error_items(record, field)
    return unless record.errors[field].any?

    record.errors.full_messages_for(field).map do |error|
      { text: error }
    end
  end

  def error_summary_items(record)
    record.errors.map do |error|
      {
        text: error.full_message,
        href: "##{record.class.name.underscore}_#{error.attribute}",
      }
    end
  end
end
