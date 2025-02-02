module DiscoveryEngine
  # Client to synchronise `Control`s to Discovery Engine
  class ControlClient
    # Creates a corresponding resource for this control on Discovery Engine.
    def create(control)
      discovery_engine_client.create_control(
        control: control.to_discovery_engine_control,
        control_id: control.discovery_engine_id,
        parent: control.parent,
      )
    rescue Google::Cloud::Error => e
      set_record_errors(control, e)
      raise ClientError, "Could not create control: #{e.message}"
    end

    # Updates the corresponding resource for this control on Discovery Engine.
    def update(control)
      discovery_engine_client.update_control(control: control.to_discovery_engine_control)
    rescue Google::Cloud::Error => e
      set_record_errors(control, e)
      raise ClientError, "Could not update control: #{e.message}"
    end

    # Deletes the corresponding resource for this control on Discovery Engine.
    def delete(control)
      discovery_engine_client.delete_control(name: control.name)
    rescue Google::Cloud::Error => e
      set_record_errors(control, e)
      raise ClientError, "Could not delete control: #{e.message}"
    end

  private

    attr_reader :control

    def set_record_errors(control, error)
      # There is no way to extract structured error information from the Google API client, so we
      # have to resort to regex matching to see if we can extract the cause of the error.
      #
      # In this case, we know that if the error message contains "filter syntax", the user probably
      # made a mistake entering the filter expression and we can attach the error to that field.
      # Otherwise, we consider it an unknown error and make sure to log it.
      case error.message
      when /filter syntax/i
        control.action.errors.add(:filter_expression, error.details)
      else
        control.errors.add(:base, :remote_error)

        GovukError.notify(error)
        Rails.logger.error(error.message)
      end
    end

    def discovery_engine_client
      Google::Cloud::DiscoveryEngine.control_service(version: :v1)
    end
  end
end
