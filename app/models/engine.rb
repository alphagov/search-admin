# Represents an engine on Discovery Engine.
#
# An engine (called "app" in the Google Cloud UI) is an abstraction over the data stores that
# contain our searchable documents, and is used for querying. It is the parent resource of several
# other resources such as controls and serving configs.
#
# Our architecture currently only has a single engine, so we do not need the ability to manage
# engines through Search Admin.
#
# see https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1/latest/Google-Cloud-DiscoveryEngine-V1-Engine
class Engine
  include DiscoveryEngineNameable

  # The ID of the default engine created through Terraform in `govuk-infrastructure`
  DEFAULT_ENGINE_ID = "govuk".freeze

  attr_reader :discovery_engine_id

  def self.default
    new(DEFAULT_ENGINE_ID)
  end

  def initialize(discovery_engine_id)
    @discovery_engine_id = discovery_engine_id
  end

  def ==(other)
    discovery_engine_id == other.discovery_engine_id
  end
end
