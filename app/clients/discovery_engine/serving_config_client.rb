module DiscoveryEngine
  # Client to synchronise `ServingConfig`s to Discovery Engine
  #
  # NOTE: As of Feb 2025, there is no support for creating or deleting serving configs on the
  # client, only updating. We operate on a fixed set of serving configs created through Terraform
  # and seeded into the app in `lib/tasks/bootstrap.rake`.
  class ServingConfigClient
    include DiscoveryEngine::Services

    # Creates a corresponding resource for this serving config on Discovery Engine.
    def create(_)
      raise NotImplementedError
    end

    # Updates the corresponding resource for this serving config on Discovery Engine.
    def update(serving_config)
      payload = serving_config.to_discovery_engine_serving_config

      serving_config_service.update_serving_config(
        serving_config: payload,
        # Ensure no fields other than the ones specified in the payload are updated
        update_mask: { paths: payload.keys.excluding(:name) },
      )
    rescue Google::Cloud::Error => e
      serving_config.errors.add(:base, :remote_error)

      GovukError.notify(e)
      Rails.logger.error(e.message)
    end

    # Deletes the corresponding resource for this serving config on Discovery Engine.
    def delete(_)
      raise NotImplementedError
    end
  end
end
