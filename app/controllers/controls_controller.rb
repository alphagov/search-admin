class ControlsController < ApplicationController
  before_action :set_control, only: %i[show edit update destroy]
  before_action :set_serving_config_options, only: %i[new create edit update]

  def index
    @controls = Control.order(:display_name)
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

  def destroy
    if @control.destroy
      redirect_to controls_path, notice: t(".success")
    else
      redirect_to @control, alert: t(".failure")
    end
  end

private

  def set_control
    @control = Control.includes(:action, :serving_configs).find(params[:id])
  end

  def set_serving_config_options
    @serving_config_options = ServingConfig
      .can_have_attached_controls
      .pluck(:id, :display_name, :comment)
  end

  def control_params
    params.expect(
      control: [
        :display_name,
        :action_type,
        {
          action_attributes: %i[boost_factor filter_expression],
          serving_config_ids: [],
        },
      ],
    )
  end
end
