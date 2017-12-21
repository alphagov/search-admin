class BetsController < ApplicationController
  def create
    @bet = Bet.new(create_params)

    if @bet.save
      RummagerNotifier.update_elasticsearch(@bet.query, :create)

      redirect_to query_path(@bet.query), notice: 'Bet created'
    else
      flash.now[:alert] = 'The bet could not be created because there are errors'
      redirect_to query_path(@bet.query)
    end
  end

  def edit
    @bet = bet
  end

  def update
    @bet = bet

    if @bet.update_attributes(bet_params)
      RummagerNotifier.update_elasticsearch(@bet.query, :update)

      redirect_to query_path(@bet.query), notice: 'Bet updated'
    else
      flash.now[:alert] = 'The bet could not be saved because there are errors'
      render 'edit'
    end
  end

  def destroy
    @bet = bet

    if @bet.destroy
      RummagerNotifier.update_elasticsearch(@bet.query, :update_bets)

      flash.notice = 'Bet deleted'
    else
      flash.alert = 'Could not delete bet'
    end

    redirect_to query_path(@bet.query)
  end

private

  def bet
    @_bet ||= Bet.find(params[:id])
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
