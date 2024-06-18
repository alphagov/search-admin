class ControlsController < ApplicationController
  def index
    @controls = Control.order(:name)
  end
end
