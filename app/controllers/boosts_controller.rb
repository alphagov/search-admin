class BoostsController < ApplicationController
  def index
    @boosts = Boost.order(:name)
  end

  def show
    @boost = Boost.find(params[:id])
  end

  def new
    @boost = Boost.new
  end

  def create
    @boost = Boost.new(boost_params)
    if @boost.save
      redirect_to @boost, notice: "Boost created successfully"
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    @boost = Boost.find(params[:id])
  end

  def update
    @boost = Boost.find(params[:id])
    if @boost.update(boost_params)
      redirect_to @boost, notice: "Boost updated successfully"
    else
      render "edit", status: :unprocessable_entity
    end
  end

private

  def boost_params
    params.require(:boost).permit(:name, :active, :boost_amount, :filter)
  end
end
