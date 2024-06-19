class ControlsController < ApplicationController
  def index
    @controls = Control.order(:name)
  end

  def show
    @control = Control.find(params[:id])
  end

  def new
    @control = Control.new
  end

  def create
    @control = Control.new(control_params)
    if @control.save
      redirect_to @control, notice: "Control created successfully"
    else
      render "new"
    end
  end

private

  def control_params
    params.require(:control).permit(:name, :active, :boost_amount, :filter)
  end
end
