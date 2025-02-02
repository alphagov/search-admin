class ControlsController < ApplicationController
  before_action :set_control, only: %i[show edit update]

  def index
    @controls = Control.includes(:action).order(:display_name)
  end

  def new
    @control = Control.new(action: params[:action_type].new)
  end

  def create
    @control = Control.new(control_params)

    if @control.save
      redirect_to @control, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    @control.assign_attributes(control_params.except(:action_type))

    if @control.save
      redirect_to @control, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
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
        :action_type,
        { action_attributes: %i[boost_factor filter_expression] },
      ],
    )
  end
end
