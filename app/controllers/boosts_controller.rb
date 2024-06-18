class BoostsController < ApplicationController
  def index
    @boosts = Boost.order(:name)
  end
end
