class RecommendedLinksController < ApplicationController
  before_action :set_recommended_link, only: %i[show edit update destroy]

  def index
    @recommended_links = RecommendedLink.order([:link])

    respond_to do |format|
      format.html
      format.csv { send_data @recommended_links.to_csv }
    end
  end

  def new
    @recommended_link = RecommendedLink.new
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
    @search_url = SearchUrl.for(@recommended_link.title)
  end

  def edit; end

  def update
    if @recommended_link.update(update_recommended_link_params)
      ExternalContentPublisher.publish(@recommended_link)

      redirect_to recommended_link_path(@recommended_link), notice: "Your external link was updated successfully"
    else
      render :edit
    end
  end

  def destroy
    if @recommended_link.destroy
      ExternalContentPublisher.unpublish(@recommended_link)

      redirect_to recommended_links_path, notice: "Your external link was deleted successfully"
    else
      redirect_to recommended_link_path(@recommended_link), alert: "We could not delete your external link"
    end
  end

private

  def set_recommended_link
    @recommended_link = RecommendedLink.find(params.expect(:id))
  end

  def create_recommended_link_params
    params.require(:recommended_link)
      .permit(:link, :title, :description, :keywords, :comment)
      .merge(user_id: current_user.id)
  end

  def update_recommended_link_params
    params.require(:recommended_link)
      .permit(:link, :title, :description, :keywords, :comment)
      .merge(user_id: current_user.id)
  end

  def check_for_duplicate_recommended_link(recommended_link)
    if recommended_link.errors.include?(:recommended_link)
      RecommendedLink.where(link: recommended_link.link).first
    end
  end
end
