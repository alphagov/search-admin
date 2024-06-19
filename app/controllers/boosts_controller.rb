class BoostsController < ApplicationController
  def index
    @boosts = Boost.order(:name)
  end

  def show
    @boost = Boost.find(params[:id])
  end
end
