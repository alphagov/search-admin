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
    @recommended_link = RecommendedLink.new(recommended_link_params)

    if @recommended_link.save
      ExternalContentPublisher.publish(@recommended_link)

      redirect_to recommended_link_path(@recommended_link), notice: t(".success")
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @recommended_link.update(recommended_link_params)
      ExternalContentPublisher.publish(@recommended_link)

      redirect_to recommended_link_path(@recommended_link), notice: t(".success")
    else
      render :edit
    end
  end

  def destroy
    if @recommended_link.destroy
      ExternalContentPublisher.unpublish(@recommended_link)

      redirect_to recommended_links_path, notice: t(".success")
    else
      redirect_to recommended_link_path(@recommended_link), alert: t(".failure")
    end
  end

private

  def set_recommended_link
    @recommended_link = RecommendedLink.find(params.expect(:id))
  end

  def recommended_link_params
    params
      .expect(recommended_link: %i[link title description keywords comment])
      .merge(user_id: current_user.id)
  end
end
