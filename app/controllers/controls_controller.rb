class ControlsController < ApplicationController
  before_action :set_control, only: %i[show]

  def index
    @controls = Control.includes(:action).order(:display_name)
  end

  def show; end

private

  def set_control
    @control = Control.includes(:action).find(params[:id])
  end
end
