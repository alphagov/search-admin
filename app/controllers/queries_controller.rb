class QueriesController < ApplicationController
  def index
    @queries = Query.includes(:best_bets, :worst_bets).order(%i(query match_type))

    respond_to do |format|
      format.html
      format.csv { send_data @queries.to_csv }
    end
  end

  def new; end

  def create
    query = Query.new(query_params)
    saver = SearchApiSaver.new(query)
    if saver.save
      redirect_to query_path(query), notice: "Your query was created successfully"
    else
      existing_query = check_for_duplicate_query(query)
      if existing_query
        redirect_to query_path(existing_query), notice: "Query already exists"
      else
        flash[:alert] = "Error creating query"
        render :new
      end
    end
  end

  def show
    @new_bet = Bet.new

    @query = find_query
    @best_bets = @query.sorted_best_bets
    @worst_bets = @query.worst_bets

    @search_url = SearchUrl.for(@query.query)
  end

  def edit
    @query = find_query
  end

  def update
    query = find_query
    saver = SearchApiSaver.new(query)

    if saver.update_attributes(query_params)
      redirect_to query_path(query), notice: "Your query was updated successfully"
    else
      flash[:alert] = "Error updating query"
      render :edit
    end
  end

  def destroy
    query = find_query
    saver = SearchApiSaver.new(query)

    if saver.destroy
      redirect_to queries_path, notice: "Your query was deleted successfully"
    else
      redirect_to query_path(query), alert: "Error deleting query"
    end
  end

private

  def find_query
    @find_query ||= Query.find(params[:id])
  end

  def query_params
    qp = params.require(:query).permit(:query, :match_type)
    qp[:query] = qp[:query].downcase
    qp
  end

  def check_for_duplicate_query(query)
    if query.errors.include?(:query)
      Query.where(query: query.query, match_type: query.match_type).first
    end
  end
end
