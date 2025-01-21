class AdjustmentsController < ApplicationController
  before_action :set_adjustment, only: %i[show]

  def index
    @adjustments = Adjustment.all
  end

  def show; end

private

  def set_adjustment
    @adjustment = Adjustment.find(params[:id])
  end
end
