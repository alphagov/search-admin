class ControlsController < ApplicationController
  before_action :set_control, only: %i[show edit update destroy]

  self.primary_navigation_area = :search
  self.secondary_navigation_area = :controls
  layout "search"

  def index
    @controls = Control.includes(:action).order(:display_name)
  end

  def new
    @control = Control.new(action: params[:action_type].new)
  end

  def create
    @control = Control.new(control_params)

    if @control.save_and_sync
      redirect_to @control, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    @control.assign_attributes(control_params.except(:action_type))

    if @control.save_and_sync
      redirect_to @control, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @control.destroy_and_sync
      redirect_to controls_path, notice: t(".success")
    else
      redirect_to @control, alert: t(".failure")
    end
  end

private

  def set_control
    @control = Control.includes(:action).find(params[:id])
  end

  def control_params
    params.expect(
      control: [
        :display_name,
        :comment,
        :action_type,
        { action_attributes: %i[boost_factor filter_expression] },
      ],
    )
  end
end
