require "uri"

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    uri = parse(value)
    unless uri&.host
      msg = options[:message] || (uri ? "does not have a valid host" : "is an invalid URL")
      record.errors[attribute] << msg
    end
  end

private

  def parse(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) ? uri : nil
  rescue URI::InvalidURIError
    nil
  end
end
