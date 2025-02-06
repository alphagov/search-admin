# Represents a data store on Discovery Engine.
#
# A data store contains the indexed documents that can be searched through an engine.
#
# Our architecture currently only has a single data store, so we do not need the ability to manage
# data stores through Search Admin.
#
# see https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1/latest/Google-Cloud-DiscoveryEngine-V1-DataStore
class DataStore
  include DiscoveryEngineNameable

  # The ID of the default datastore created through Terraform in `govuk_infrastructure`
  DEFAULT_DATA_STORE_ID = "govuk_content".freeze

  attr_reader :discovery_engine_id

  def self.default
    new(DEFAULT_DATA_STORE_ID)
  end

  def initialize(discovery_engine_id)
    @discovery_engine_id = discovery_engine_id
  end

  def ==(other)
    discovery_engine_id == other.discovery_engine_id
  end
end
