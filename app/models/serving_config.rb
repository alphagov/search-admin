# Represents a serving config(uration) on Discovery Engine.
#
# A serving config is an endpoint on an engine that clients (such as Search API v2) can query to get
# search results.
#
# Each serving config can have different sets of controls attached to it. We have a default serving
# config that is used by Search API v2 for actual GOV.UK traffic, but we can also have additional
# serving configs to try out different combinations of controls or other settings.
#
# see https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1beta/latest/Google-Cloud-DiscoveryEngine-V1beta-ServingConfig
class ServingConfig < ApplicationRecord
  # The ID on Discovery Engine of the "default" serving config. This is the primary, "live" serving
  # config used by Search API v2.
  DEFAULT_SERVING_CONFIG_ID = "govuk_default".freeze

  # The ID on Discovery Engine cannot be changed after creation
  attr_readonly :discovery_engine_id

  validates :discovery_engine_id, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :comment, presence: true

  before_destroy :prevent_destruction_of_default

  # Returns the default serving config
  def self.default
    find_by!(discovery_engine_id: DEFAULT_SERVING_CONFIG_ID)
  end

  # Returns a relation for all serving configs that can have attached controls
  def self.can_have_attached_controls
    where(can_have_attached_controls: true)
  end

  # Returns whether this serving config is the default serving config
  def default?
    discovery_engine_id == DEFAULT_SERVING_CONFIG_ID
  end

private

  # Prevent deletion of the default serving config (as that is used for live search)
  def prevent_destruction_of_default
    return unless default?

    errors.add(:base, "Cannot delete default serving config")
    throw :abort
  end
end
