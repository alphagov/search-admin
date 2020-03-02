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
    date_complete? ? DateParser.new(date_hash).date : ""
  end

  def date_hash
    bet_params[:expiration_date].to_h.deep_symbolize_keys
  end

  def date_complete?
    date_hash.values.reject(&:empty?).count == 3
  end

  def best_bet?
    !is_worst_bet?
  end

  def is_worst_bet?
    bet_params[:is_worst] == "1"
  end
end
