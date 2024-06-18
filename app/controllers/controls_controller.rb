class ControlsController < ApplicationController
  def index
    @controls = Control.order(:display_name)
  end
end
