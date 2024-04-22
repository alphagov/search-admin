module FormsHelper
  def error_items(record, field)
    return unless record.errors[field].any?

    record.errors[field].map do |error|
      { text: "#{field.to_s.humanize} #{error}" }
    end
  end
end
