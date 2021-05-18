require "uri"

class BetLinkValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    @record = record
    @attribute = attribute
    uri = parse(value)

    return record_error("couldn't be parsed as a URL") if value.blank? || uri.nil?

    return validate_external_link(uri, value) if uri&.absolute?

    validate_path(value)
  end

private

  def validate_external_link(uri, value)
    if RecommendedLink.find_by(link: value).nil?
      if %w[www.gov.uk gov.uk].include?(uri.host)
        record_error("looks like an internal link so should just be a path: use /random, not gov.uk/random.")
      else
        record_error("looks like an external link, so you should first create a recommended link in search admin (click External links)")
      end
    end

    unless uri.is_a?(URI::HTTP)
      record_error("looks like an external link, so you should prepend it with http:// or https://, like https://#{value}")
    end
  end

  def validate_path(value)
    if value.nil? || value[0] != "/"
      record_error("looks like an internal link, so should be formatted like /my-link, with a forward slash")
    end
  end

  def record_error(msg)
    @record.errors[@attribute] << msg
  end

  def parse(value)
    URI.parse(value)
  rescue URI::InvalidURIError
    nil
  end
end
