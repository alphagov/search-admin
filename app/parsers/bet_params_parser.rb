class BetParamsParser
  attr_reader :bet_params, :user_id

  def initialize(bet_params, user_id)
    @bet_params = bet_params
    @user_id = user_id
  end

  def bet_attributes
    bet_params.merge(
      expiration_date: date_attributes,
      user_id: user_id,
      manual: true,
      is_best: best_bet?,
    )
  end

private

  def date_attributes
    dates_provided? ? parse_date(date_params) : ""
  end

  def date_params
    bet_params[:expiration_date]
  end

  def dates_provided?
    date_params.values.join.present?
  end

  def parse_date(date)
    d = date["day"].to_i
    m = date["month"].to_i
    y = date["year"].to_i
    Time.zone.local(y, m, d)
  end

  def best_bet?
    !is_worst_bet?
  end

  def is_worst_bet?
    bet_params[:is_worst] == "1"
  end
end
