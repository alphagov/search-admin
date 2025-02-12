require "google/cloud/discovery_engine/v1beta"

module DiscoveryEngine
  # Client to reset remote state on Discovery Engine.
  #
  # This is useful for non-production environments where we want to recreate the state of the app
  # remotely from our local state, for example after a scheduled database import from a "higher"
  # environment.
  class PurgeClient
    def purge!
      # Reset controls for all serving configs
      serving_config_client.list_serving_configs(parent: Engine.default.name).each do |serving_config|
        Rails.logger.info("[PurgeClient] Detaching all controls from #{serving_config.name}}")

        # TODO: Add something like `#serving_config_attachment_field_name` to actions
        # and use that
        serving_config.boost_control_ids.clear
        serving_config.filter_control_ids.clear

        serving_config_client.update_serving_config(
          serving_config:,
          update_mask: {
            paths: %w[
              boost_control_ids
              filter_control_ids
            ]
          }
        )
      end

      # Delete all controls
      control_client.list_controls(parent: Engine.default.name).each do |control|
        Rails.logger.info("[PurgeClient] Deleting control #{control.name}")

        control_client.delete_control(name: control.name)
      end
    end

  private

    def serving_config_client
      # NOTE: As of Feb 2025, there is no convenience method on `DiscoveryEngine` to get a
      # `ServingConfigService::Client` (presumably as it's only available in beta)
      @serving_config_client ||= Google::Cloud::DiscoveryEngine::V1beta::ServingConfigService::Client.new
    end

    def control_client
      @control_client ||= Google::Cloud::DiscoveryEngine.control_service(version: :v1)
    end
  end
end
