# Unlike the main `Google::Cloud::DiscoveryEngine` entrypoint, the beta libraries are not required
# by default and need manual loading. Remove this when we no longer need v1beta.
require "google/cloud/discovery_engine/v1beta"

module DiscoveryEngine
  # Mixin providing access to the Discovery Engine API client's services
  module Services
    # Returns a Discovery Engine client for the completion service
    def completion_service
      @completion_service ||= Google::Cloud::DiscoveryEngine.completion_service(version: :v1)
    end

    # Returns a Discovery Engine client for the control service
    def control_service
      @control_service ||= Google::Cloud::DiscoveryEngine.control_service(version: :v1)
    end

    # Returns a Discovery Engine client for the serving config service
    def serving_config_service
      # TODO: As of version 2.0 of the Discovery Engine client, beta services can no longer be
      # initialized using the main entrypoint, so we need to manually instantiate a beta service
      # client instance. Once the serving config service graduates into `v1`, we should use this
      # instead:
      # ```
      # Google::Cloud::DiscoveryEngine.serving_config_service(version: :v1)
      # ```
      @serving_config_service ||= Google::Cloud::DiscoveryEngine::V1beta::
                                    ServingConfigService::Client.new
    end
  end
end
