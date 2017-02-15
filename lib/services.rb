require 'gds_api/rummager'

module Services
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
