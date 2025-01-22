class AdjustmentsController < ApplicationController
  before_action :set_adjustment, only: %i[show edit update destroy]

  def index
    @adjustments = Adjustment.all
  end

  def new
    redirect_to(adjustments_path) unless Adjustment.kinds.include?(params[:kind])

    @adjustment = Adjustment.new(kind: params[:kind])
  end

  def create
    @adjustment = Adjustment.new(adjustment_params)

    if @adjustment.save_and_sync
      redirect_to @adjustment, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    @adjustment.assign_attributes(adjustment_params)

    if @adjustment.save_and_sync
      redirect_to @adjustment, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @adjustment.destroy_and_sync
      redirect_to adjustments_path, notice: t(".success")
    else
      redirect_to @adjustment, alert: t(".failure")
    end
  end

private

  def set_adjustment
    @adjustment = Adjustment.find(params[:id])
  end

  def adjustment_params
    params.expect(adjustment: %i[kind name filter_expression boost_factor])
  end
end
