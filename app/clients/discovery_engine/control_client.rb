module DiscoveryEngine
  # Client to synchronise `Control`s to Discovery Engine
  class ControlClient
    include DiscoveryEngine::Services

    # Creates a corresponding resource for this control on Discovery Engine.
    def create(control)
      control_service.create_control(
        control: control.to_discovery_engine_control,
        control_id: control.remote_resource_id,
        parent: control.parent.name,
      )
    end

    # Updates the corresponding resource for this control on Discovery Engine.
    def update(control)
      control_service.update_control(control: control.to_discovery_engine_control)
    end

    # Deletes the corresponding resource for this control on Discovery Engine.
    def delete(control)
      control_service.delete_control(name: control.name)
    end

  private

    attr_reader :control
  end
end
