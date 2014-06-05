class QueriesController < ApplicationController
  def index
    @queries = Query.all.order([:query, :match_type])
  end

  def new; end

  def create
    query = Query.create(query_params)

    redirect_to query_path(query)
  end

  def show
    @new_bet = Bet.new

    @query = Query.find(params[:id])
    @best_bets = @query.best_bets
  end

private

  def query_params
    params.require(:query).permit(:query, :match_type)
  end
end
