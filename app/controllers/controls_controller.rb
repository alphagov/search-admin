class ControlsController < ApplicationController
  def index
    @controls = Control.order(:name)
  end

  def show
    @control = Control.find(params[:id])
  end
end
