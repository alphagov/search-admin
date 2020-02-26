class BetParamsParser
  attr_reader :bet_params, :user_id

  def initialize(bet_params, user_id)
    @bet_params = bet_params
    @user_id = user_id
  end

  def bet_attributes
    bet_params.merge(
      user_id: user_id,
      manual: true,
      is_best: best_bet?,
    )
  end

private

  def best_bet?
    !is_worst_bet?
  end

  def is_worst_bet?
    bet_params[:is_worst] == "1"
  end
end
