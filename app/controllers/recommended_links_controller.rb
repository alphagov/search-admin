class RecommendedLinksController < ApplicationController
  def index
    @recommended_links = RecommendedLink.order([:link])

    respond_to do |format|
      format.html
      format.csv { send_data @recommended_links.to_csv }
    end
  end

  def new
    @recommended_link = RecommendedLink.new(content_id: SecureRandom.uuid)
  end

  def create
    @recommended_link = RecommendedLink.new(create_recommended_link_params)

    if @recommended_link.save
      ExternalContentPublisher.publish(@recommended_link)

      redirect_to recommended_link_path(@recommended_link), notice: "Your external link was created successfully"
    else
      render :new
    end
  end

  def show
    @recommended_link = find_recommended_link
    @search_url = SearchUrl.for(@recommended_link.title)
  end

  def edit
    @recommended_link = find_recommended_link
  end

  def update
    @recommended_link = find_recommended_link

    if @recommended_link.update(update_recommended_link_params)
      ExternalContentPublisher.publish(@recommended_link)

      redirect_to recommended_link_path(@recommended_link), notice: "Your external link was updated successfully"
    else
      render :edit
    end
  end

  def destroy
    recommended_link = find_recommended_link

    if recommended_link.destroy
      ExternalContentPublisher.unpublish(recommended_link)

      redirect_to recommended_links_path, notice: "Your external link was deleted successfully"
    else
      redirect_to recommended_link_path(recommended_link), alert: "We could not delete your external link"
    end
  end

private

  def find_recommended_link
    @find_recommended_link ||= RecommendedLink.find(params[:id])
  end

  def create_recommended_link_params
    params.require(:recommended_link)
      .permit(:link, :title, :description, :keywords, :comment)
      .merge(user_id: current_user.id, content_id: SecureRandom.uuid)
  end

  def update_recommended_link_params
    params.require(:recommended_link)
      .permit(:link, :title, :description, :keywords, :comment)
      .merge(user_id: current_user.id)
  end
end
