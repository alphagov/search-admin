class DiscoveryEngineControlsController < ApplicationController
  before_action :set_discovery_engine_control, only: %i[show]

  def index
    @discovery_engine_controls = DiscoveryEngineControl.all
  end

  def show; end

private

  def set_discovery_engine_control
    @discovery_engine_control = DiscoveryEngineControl.find(params.expect(:id))
  end
end
