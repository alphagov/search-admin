class BestBetsController < ApplicationController
  before_filter :find_best_bet, only: [:edit, :update, :destroy]

  def index
    @best_bets = BestBet.all

    respond_to do |format|
      format.html
      format.csv { send_data @best_bets.to_csv }
    end
  end

  def new;
    @best_bet = BestBet.new
  end

  def create
    create_params = best_bet_params.merge(
      user_id: current_user.id,
      manual: true
    )

    @best_bet = BestBet.new(create_params)

    if @best_bet.save
      notify_best_bet_changed(@best_bet)

      flash.notice = 'Best bet created'
      redirect_to best_bets_path
    else
      flash.now[:alert] = 'Could not create best bet'
      render 'new'
    end
  end

  def edit; end

  def update
    if @best_bet.update_attributes(best_bet_params)
      notify_best_bet_changed(@best_bet)

      flash.notice = 'Best bet updated'
      redirect_to best_bets_path
    else
      flash.now[:alert] = 'Could not update best bet'
      render 'edit'
    end
  end

  def destroy
    if @best_bet.destroy
      flash.notice = 'Best bet deleted'
    else
      flash.alert = 'Could not delete best bet'
    end

    redirect_to best_bets_path
  end

private

  def find_best_bet
    @best_bet = BestBet.find(params[:id])
  end

  def best_bet_params
    params.require(:best_bet).permit(
      :query, :match_type, :link,
      :position, :comment, :source
    )
  end

  def notify_best_bet_changed(best_bet)
    attrs_to_send = best_bet.attributes.symbolize_keys.slice(:query, :match_type, :link, :position)
    SearchAdmin.services(:message_bus).notify(:best_bet_changed, attrs_to_send)
  end

end
