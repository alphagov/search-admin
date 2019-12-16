require "gds_api/search"
require "gds_api/publishing_api_v2"

module Services
  def self.publishing_api
    @publishing_api ||= GdsApi::PublishingApiV2.new(
      Plek.find("publishing-api"),
      bearer_token: ENV["PUBLISHING_API_BEARER_TOKEN"] || "example",
    )
  end

  # TODO: update RUMMAGER_BEARER_TOKEN to SEARCH_API_BEARER_TOKEN
  def self.search_api
    @search_api ||=
      GdsApi::Search.new(
        Plek.current.find("search"),
        api_version: "V2",
        bearer_token: ENV["RUMMAGER_BEARER_TOKEN"] || "example",
      )
  end
end
