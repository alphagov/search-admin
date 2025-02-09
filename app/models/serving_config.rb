# Represents a serving config(uration) on Discovery Engine.
#
# A serving config is a specific endpoint on an engine which is used for querying.
#
# Having more than one serving config on an engine is helpful because each one can have different
# sets of controls attached to it. We have one default serving config which is used for live GOV.UK
# Search, as well as a number of secondary ones for previewing and debugging purposes.
#
# see https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1beta/latest/Google-Cloud-DiscoveryEngine-V1beta-ServingConfig
class ServingConfig < ApplicationRecord
  # The remote resource ID of the default serving config (the one used as default by Search API v2
  # for live user queries)
  DEFAULT_REMOTE_RESOURCE_ID = "govuk_default".freeze

  include DiscoveryEngineNameable

  # Don't allow changing remote_resource_id after creation
  attr_readonly :remote_resource_id

  validates :display_name, presence: true
  validates :remote_resource_id, presence: true, uniqueness: true

  # Returns the default serving config
  def self.default
    find_by!(remote_resource_id: DEFAULT_REMOTE_RESOURCE_ID)
  end

  # Returns whether the current serving config is the default
  def default?
    remote_resource_id == DEFAULT_REMOTE_RESOURCE_ID
  end
end
