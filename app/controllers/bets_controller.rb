class BetsController < ApplicationController
  def create
    create_params = bet_params.merge(
      user_id: current_user.id,
      manual: true
    )

    @bet = Bet.new(create_params)

    if @bet.save
      notify_bet_changed(@bet)

      flash.notice = 'Bet created'
    else
      flash.now[:alert] = 'The bet could not be created because there are errors'
    end

    if query = @bet.query
      redirect_to query_path(@bet.query)
    else
      redirect_to queries_path
    end
  end

  def edit
    @bet = Bet.find(params[:id])
  end

  def update
    @bet = Bet.find(params[:id])

    if @bet.update_attributes(bet_params)
      notify_bet_changed(@bet)

      flash.notice = 'Bet updated'
      redirect_to query_path(@bet.query)
    else
      flash.now[:alert] = 'The bet could not be saved because there are errors'
      render 'edit'
    end
  end

  def destroy
    @bet = Bet.find(params[:id])

    if @bet.destroy
      notify_bet_changed(@bet)

      flash.notice = 'Bet deleted'
    else
      flash.alert = 'Could not delete bet'
    end

    redirect_to query_path(@bet.query)
  end

private

  def bet_params
    params.require(:bet).permit(
      :query, :match_type, :link,
      :position, :comment, :source,
      :query_id
    )
  end

  def notify_bet_changed(bet)
    query = bet.query
    SearchAdmin.services(:message_bus).notify(:bet_changed, [[query.query, query.match_type]])
  end

end
