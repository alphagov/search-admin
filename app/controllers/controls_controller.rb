class ControlsController < ApplicationController
  def index
    @controls = Control.order(:display_name)
  end

  def show
    @control = Control.find(params[:id])
  end
end
