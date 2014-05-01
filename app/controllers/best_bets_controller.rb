class BestBetsController < ApplicationController

  def index; end

  def new; end

  def create
    if BestBet.create(best_bet_params)
      flash.notice = 'Best bet created'
      redirect_to best_bets_path
    else
      flash.alert = 'Could not create best bet'
      render 'new'
    end
  end

  def edit; end

  def update
    if best_bet.update_attributes(best_bet_params)
      flash.notice = 'Best bet updated'
      redirect_to best_bets_path
    else
      flash.alert = 'Could not update best bet'
      render 'edit'
    end
  end

  def destroy
    if best_bet.destroy
      flash.notice = 'Best bet deleted'
    else
      flash.alert = 'Could not delete best bet'
    end

    redirect_to best_bets_path
  end

private

  def best_bet
    if params[:id]
      BestBet.find(params[:id])
    else
      BestBet.new
    end
  end
  helper_method :best_bet

  def best_bet_params
    params.require(:best_bet).permit(
      :query, :match_type, :link,
      :position, :comment, :source
    )
  end

end
