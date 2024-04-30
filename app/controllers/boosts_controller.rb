class BoostsController < ApplicationController
  def index
    @boosts = Boost.all
  end
end
