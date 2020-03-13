class BetsController < ApplicationController
  def create
    attrs = param_parser.bet_attributes
    @bet = Bet.new(attrs)
    unless admin_user?
      @bet.set_defaults
    end
    saver = SearchApiSaver.new(@bet)

    if saver.save
      redirect_to query_path(@bet.query), notice: "Bet created"
    else
      redirect_to query_path(@bet.query), alert: "Error creating bet. #{@bet.errors.full_messages.to_sentence}"
    end
  end

  def edit
    @bet = find_bet
  end

  def update
    @bet = find_bet
    if !admin_user? && reactivating?
      @bet.set_defaults
    end
    saver = SearchApiSaver.new(@bet)
    if saver.update(update_attrs)
      redirect_to query_path(@bet.query), notice: notice
    else
      flash.now[:alert] = "Error updating bet. #{@bet.errors.full_messages.to_sentence}"
      render "edit"
    end
  end

  def deactivate
    @bet = find_bet
    saver = SearchApiSaver.new(@bet)
    if saver.destroy(action: :deactivate)
      redirect_to query_path(@bet.query), notice: "Bet deactivated"
    else
      redirect_to query_path(@bet.query), alert: "Error deactivating bet"
    end
  end

  def destroy
    @bet = find_bet
    saver = SearchApiSaver.new(@bet)

    if saver.destroy(action: :update_bets)
      flash.notice = "Bet deleted"
    else
      flash.alert = "Error deleting bet"
    end

    redirect_to query_path(@bet.query)
  end

private

  def find_bet
    @find_bet ||= Bet.find(params[:id])
  end

  def bet_params
    params.require(:bet).permit(
      :comment,
      :is_worst,
      :link,
      :match_type,
      :position,
      :query,
      :query_id,
      :source,
      :permanent,
      expiration_date: %i[day month year],
    )
  end

  def param_parser
    BetParamsParser.new(bet_params, current_user.id)
  end

  def reactivating?
    params["bet"]["active"] == "true"
  end

  def notice
    reactivating? ? "Bet reactivated" : "Bet updated"
  end

  def update_attrs
    admin_user? ? param_parser.bet_attributes : param_parser.bet_attributes.except(:expiration_date, :permanent)
  end
end
