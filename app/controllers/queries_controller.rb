class QueriesController < ApplicationController
  include Notifiable

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
      store_updated_attributes_for(query)
      send_change_notification

      redirect_to query_path(query), notice: "Your query was created successfully"
    else
      if query.errors.include?(:query)
        if existing_query = Query.where(query: query.query, match_type: query.match_type).first
          flash[:notice] = "The query you created already exists"
          redirect_to query_path(existing_query)
          return
        end
      end

      flash[:alert] = "We could not create your query"
      render :new
    end
  end

  def show
    @new_bet = Bet.new

    @query = find_query
    @best_bets = @query.best_bets
    @worst_bets = @query.worst_bets
  end

  def edit
    @query = find_query
  end

  def update
    query = find_query

    store_previous_attributes_for(query)

    if query.update_attributes(query_params)
      store_updated_attributes_for(query)
      send_change_notification

      redirect_to query_path(query), notice: "Your query was updated successfully"
    else
      flash[:alert] = "We could not update your query"
      render :edit
    end
  end

  def destroy
    query = find_query

    if query.destroy
      store_updated_attributes_for(query)
      send_change_notification

      redirect_to queries_path, notice: "Your query was deleted successfully"
    else
      redirect_to query_path(query), alert: "We could not delete your query"
    end
  end

private

  def find_query
    @_query ||= Query.find(params[:id])
  end

  def query_params
    qp = params.require(:query).permit(:query, :match_type)
    qp[:query] = qp[:query].downcase
    qp
  end
end
