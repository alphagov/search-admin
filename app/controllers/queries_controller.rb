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

  def edit
    @query = Query.find(params[:id])
  end

  def update
    query = Query.find(params[:id])

    previous_query_text = query.query
    previous_query_match_type = query.match_type

    if query.update_attributes(query_params)
      notify_of_new_query(query, previous_query_text: previous_query_text, previous_query_match_type: previous_query_match_type)

      flash[:notice] = "Your query was updated successfully"
      redirect_to query_path(query)
    else
      flash[:alert] = "We could not update your query"
      render :edit
    end
  end

  def destroy
    query = Query.find(params[:id])

    if query.destroy
      notify_of_new_query(query)

      flash[:notice] = "Your query was deleted successfully"
      redirect_to queries_path
    else
      flash[:alert] = "We could not delete your query"
      redirect_to query_path(query)
    end
  end

private

  def query_params
    params.require(:query).permit(:query, :match_type)
  end

  def notify_of_new_query(query, previous_query_text: nil, previous_query_match_type: nil)
    if previous_query_text && previous_query_match_type
      queries_to_notify_about = [[query.query, query.match_type], [previous_query_text, previous_query_match_type]]
    else
      queries_to_notify_about = [[query.query, query.match_type]]
    end

    SearchAdmin.services(:message_bus).notify(:bet_changed, queries_to_notify_about)
  end
end
