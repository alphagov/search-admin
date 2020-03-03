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

  # rubocop:disable Rails/ActiveRecordAliases
  def update
    @bet = find_bet
    saver = SearchApiSaver.new(@bet)
    attrs =
      if admin_user?
        param_parser.bet_attributes
      else
        param_parser.bet_attributes.except(:expiration_date, :permanent)
      end
    if saver.update_attributes(attrs)
      redirect_to query_path(@bet.query), notice: "Bet updated"
    else
      flash.now[:alert] = "Error updating bet"
      render "edit"
    end
  end
  # rubocop:enable Rails/ActiveRecordAliases

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
end
