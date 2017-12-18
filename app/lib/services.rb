require 'gds_api/rummager'
require 'gds_api/publishing_api_v2'

module Services
  def self.publishing_api
    @publishing_api ||= GdsApi::PublishingApiV2.new(
      Plek.find('publishing-api'),
      bearer_token: ENV['PUBLISHING_API_BEARER_TOKEN'] || 'example',
    )
  end

  def self.rummager_index_metasearch
    @rummager_index_metasearch ||=
      GdsApi::Rummager.new(Plek.current.find('rummager') + '/metasearch')
  end

  def self.rummager_index_mainstream
    @rummager_index_mainstream ||=
      GdsApi::Rummager.new(Plek.current.find('rummager') + '/mainstream')
  end

  def self.rummager
    @rummager ||=
      GdsApi::Rummager.new(Plek.current.find('search'), disable_cache: true)
  end
end
