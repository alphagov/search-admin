require "gds_api/rummager"
require "gds_api/publishing_api_v2"

module Services
  def self.publishing_api
    @publishing_api ||= GdsApi::PublishingApiV2.new(
      Plek.find("publishing-api"),
      bearer_token: ENV["PUBLISHING_API_BEARER_TOKEN"] || "example",
    )
  end

  def self.rummager
    @rummager ||=
      GdsApi::Rummager.new(
        Plek.current.find("search"),
        api_version: "V2",
        bearer_token: ENV["RUMMAGER_BEARER_TOKEN"] || "example",
      )
  end
end
