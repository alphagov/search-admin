module FormsHelper
  def error_items(record, field)
    return unless record.errors[field].any?

    record.errors[field].map do |error|
      { text: "#{field.to_s.humanize} #{error}" }
    end
  end

  def error_summary_items(record)
    record.errors.map do |error|
      {
        text: "#{error.attribute.to_s.humanize} #{error.message}",
        href: "##{record.class.name.underscore}_#{error.attribute}",
      }
    end
  end
end
