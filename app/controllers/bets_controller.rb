class BetsController < ApplicationController
  def create
    @bet = Bet.new(create_params)
    saver = SearchApiSaver.new(@bet)
    if saver.save
      redirect_to query_path(@bet.query), notice: "Bet created"
    else
      redirect_to query_path(@bet.query), alert: "Error creating bet."
    end
  end

  def edit
    @bet = find_bet
  end

  def update
    @bet = find_bet
    saver = SearchApiSaver.new(@bet)

    if saver.update_attributes(bet_params)
      redirect_to query_path(@bet.query), notice: "Bet updated"
    else
      flash.now[:alert] = "Error updating bet"
      render "edit"
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
    )
  end

  def create_params
    bet_params.merge(user_id: current_user.id, manual: true, is_best: best_bet?)
  end

  def best_bet?
    !is_worst_bet?
  end

  def is_worst_bet?
    bet_params.delete(:is_worst).to_i == 1
  end
end
