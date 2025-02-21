class ServingConfigsController < ApplicationController
  before_action :set_serving_config, only: %i[show]

  self.primary_navigation_area = :search
  self.secondary_navigation_area = :serving_configs
  layout "search"

  def index
    @serving_configs = ServingConfig.order(:use_case, :display_name)
  end

  def show; end

private

  def set_serving_config
    @serving_config = ServingConfig.includes(:controls).find(params[:id])
  end
end
