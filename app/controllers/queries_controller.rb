class QueriesController < ApplicationController
  def index
    @queries = Query.all.order([:query, :match_type])

    respond_to do |format|
      format.html
      format.csv { send_data @queries.to_csv }
    end
  end

  def new; end

  def create
    query = Query.new(query_params)
    if query.save
      notify_of_new_query(query)

      flash[:notice] = "Your query was created successfully"
      redirect_to query_path(query)
    else
      flash[:alert] = "We could not create your query"
      render :new
    end
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

  def notify_of_new_query(query)
    SearchAdmin.services(:message_bus).notify(:bet_changed, [[query.query, query.match_type]])
  end
end
