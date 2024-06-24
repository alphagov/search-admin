require "gds_api/search"
require "gds_api/publishing_api"

# TODO: Required for serving config API (see below)
require "google/cloud/discovery_engine/v1beta"

module Services
  def self.publishing_api
    @publishing_api ||= GdsApi::PublishingApi.new(
      Plek.find("publishing-api"),
      bearer_token: ENV["PUBLISHING_API_BEARER_TOKEN"] || "example",
    )
  end

  def self.discovery_engine_control
    @discovery_engine_control ||= ::Google::Cloud::DiscoveryEngine.control_service(
      version: :v1,
    )
  end

  def self.discovery_engine_serving_config
    # TODO: This uses the beta API as the stable API does not yet support managing serving configs
    #       as of June 2024. This should be updated to use the stable API using
    #       `serving_config_service` (like with `.discovery_engine_control`) once it is available.
    @discovery_engine_serving_config ||= ::Google::Cloud::DiscoveryEngine::V1beta::ServingConfigService::Client.new
  end
end
