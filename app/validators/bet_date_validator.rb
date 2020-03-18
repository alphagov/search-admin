class BetDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    @record = record
    @attribute = attribute
    @value = value

    validations
  end

private

  attr_reader :record, :attribute, :value

  def validations
    if expiration_date_missing?
      record_error("is invalid")
    end
    if expiration_date_in_past?
      record_error("can't be in the past")
    end
  end

  def expiration_date_missing?
    record.permanent == false && value.nil?
  end

  def expiration_date_in_past?
    record.expiration_date.present? && record.expiration_date < Time.zone.today
  end

  def record_error(msg)
    record.errors[attribute] << msg
  end
end
