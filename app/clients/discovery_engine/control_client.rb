module DiscoveryEngine
  # Client to synchronise `Control`s to Discovery Engine
  class ControlClient
    # Creates a corresponding resource for this control on Discovery Engine.
    def create(control)
      discovery_engine_client.create_control(
        control: control.to_upstream,
        control_id: control.upstream_id,
        parent: control.parent,
      )
    end

    # Updates the corresponding resource for this control on Discovery Engine.
    def update(control)
      discovery_engine_client.update_control(control: control.to_upstream)
    end

    # Deletes the corresponding resource for this control on Discovery Engine.
    def delete(control)
      discovery_engine_client.delete_control(name: control.name)
    end

  private

    attr_reader :control

    def discovery_engine_client
      Google::Cloud::DiscoveryEngine.control_service(version: :v1)
    end
  end
end
