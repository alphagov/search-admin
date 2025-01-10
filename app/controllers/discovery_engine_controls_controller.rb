class DiscoveryEngineControlsController < ApplicationController
  def index
    @discovery_engine_controls = DiscoveryEngineControl.all
  end
end
