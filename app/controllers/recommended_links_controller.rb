class RecommendedLinksController < ApplicationController
  def index
    @recommended_links = RecommendedLink.order([:title])

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
      RummagerLinkSynchronize.put(@recommended_link)

      redirect_to recommended_link_path(@recommended_link), notice: "Your recommended link was created successfully"
    else
      flash[:alert] = "We could not create your recommended link"
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
    old_recommended_link = RecommendedLink.new(link: @recommended_link.link)

    if @recommended_link.update_attributes(update_recommended_link_params)

      # Delete the record from rummager if the link has changed
      if @recommended_link.link != old_recommended_link.link
        RummagerLinkSynchronize.delete(old_recommended_link)
      end

      RummagerLinkSynchronize.put(@recommended_link)

      redirect_to recommended_link_path(@recommended_link), notice: "Your recommended link was updated successfully"
    else
      flash[:alert] = "We could not update your recommended link"
      render :edit
    end
  end

  def destroy
    recommended_link = find_recommended_link

    if recommended_link.destroy
      RummagerLinkSynchronize.delete(recommended_link)

      redirect_to recommended_links_path, notice: "Your recommended link was deleted successfully"
    else
      redirect_to recommended_link_path(recommended_link), alert: "We could not delete your recommended link"
    end
  end

private

  def find_recommended_link
    @_recommended_link ||= RecommendedLink.find(params[:id])
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
