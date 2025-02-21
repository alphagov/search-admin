class ControlAttachmentsController < ApplicationController
  before_action :set_serving_config, :set_controls

  self.primary_navigation_area = :search
  self.secondary_navigation_area = :serving_configs
  layout "search"

  def edit; end

  def update
    @serving_config.control_ids = control_ids_param

    if @serving_config.save_and_sync
      redirect_to serving_config_path(@serving_config), notice: t(".success")
    else
      render :edit
    end
  end

private

  def set_controls
    @controls = Control.all
  end

  def set_serving_config
    @serving_config = ServingConfig
      .user_editable
      .includes(:controls)
      .find(params[:serving_config_id])
  end

  def control_ids_param
    params.dig(:serving_config, :control_ids) || []
  end
end
