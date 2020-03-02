class DateParser
  attr_reader :day, :month, :year

  def initialize(day:, month:, year:)
    @day = day
    @month = month
    @year = year
  end

  def date
    begin
      Time.zone.local(year, month, day)
    rescue ArgumentError
      ""
    end
  end
end
