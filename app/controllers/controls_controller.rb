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

  def edit
    @control = Control.find(params[:id])
  end

  def update
    @control = Control.find(params[:id])
    if @control.update(control_params)
      redirect_to @control, notice: "Control updated successfully"
    else
      render "edit"
    end
  end

  def destroy
    @control = Control.find(params[:id])

    if @control.destroy
      redirect_to controls_path, notice: "Control deleted successfully"
    else
      redirect_to @control, alert: "Control could not be deleted. Try again later."
    end
  end

private

  def control_params
    params.require(:control).permit(:name, :active, :boost_amount, :filter)
  end
end
