module DiscoveryEngine
  # Client to synchronise `Control`s to Discovery Engine
  #
  # Objects synced through this client should implement the following methods:
  # - `name` / `remote_resource_id` (through `DiscoveryEngineNameable`)
  # - `parent` (the engine to which the control belongs)
  # - `discovery_engine_control_type` (the type of control, e.g. `:filter`)
  # - `to_discovery_engine_control` (a hash representing the control for the Discovery Engine API)
  class ControlClient
    include DiscoveryEngine::Services

    # Checks if a corresponding resource for this control exists on Discovery Engine.
    def exists?(control)
      control_service.get_control(name: control.name)
      true
    rescue Google::Cloud::NotFoundError
      false
    end

    # Creates a corresponding resource for this control on Discovery Engine and attaches it to the
    # default serving config.
    def create(control)
      control_service.create_control(
        control: control.to_discovery_engine_control,
        control_id: control.remote_resource_id,
        parent: control.parent.name,
      )

      serving_config_service.get_serving_config(name: ServingConfig.default.name) do |serving_config|
        attachment_method = :"#{control.discovery_engine_control_type}_control_ids"
        serving_config.public_send(attachment_method).push(control.remote_resource_id)

        serving_config_service.update_serving_config(serving_config:)
      end
    end

    # Updates the corresponding resource for this control on Discovery Engine.
    def update(control)
      control_service.update_control(control: control.to_discovery_engine_control)
    end

    # Creates a corresponding resource for this control on Discovery Engine if it does not exist, or
    # updates it if it does.
    def create_or_update(control)
      if exists?(control)
        update(control)
      else
        create(control)
      end
    end

    # Detaches the corresponding resource for this control from the default serving config and
    # deletes it from Discovery Engine.
    def delete(control)
      serving_config_service.get_serving_config(name: ServingConfig.default.name) do |serving_config|
        attachment_method = :"#{control.discovery_engine_control_type}_control_ids"
        serving_config.public_send(attachment_method).delete(control.remote_resource_id)

        serving_config_service.update_serving_config(serving_config:)
      end

      control_service.delete_control(name: control.name)
    end

    # Deletes the corresponding resource for this control from Discovery Engine if it exists.
    def delete_if_exists(control)
      delete(control) if exists?(control)
    end

  private

    attr_reader :control
  end
end
