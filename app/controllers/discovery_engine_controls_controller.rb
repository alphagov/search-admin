class DiscoveryEngineControlsController < ApplicationController
  include HumanModelTranslations

  before_action :set_discovery_engine_control, only: %i[destroy edit show update]

  def index
    @discovery_engine_controls = DiscoveryEngineControl.all
  end

  def show; end

  def new
    @discovery_engine_control = DiscoveryEngineControl.new
  end

  def edit; end

  def create
    @discovery_engine_control = DiscoveryEngineControl.new(discovery_engine_control_params)

    if @discovery_engine_control.save
      redirect_to @discovery_engine_control, notice: "#{human_record_name} was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @discovery_engine_control.update(discovery_engine_control_params)
      redirect_to @discovery_engine_control, notice: "#{human_record_name} was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @discovery_engine_control.destroy!
    redirect_to discovery_engine_controls_path, notice: "#{human_record_name} was successfully destroyed.", status: :see_other
  end

private

  def set_discovery_engine_control
    @discovery_engine_control = DiscoveryEngineControl.find(params.expect(:id))
  end

  def discovery_engine_control_params
    params.expect(discovery_engine_control: %i[name active action filter boost_amount])
  end
end
