# Represents a serving config(uration) on Discovery Engine.
#
# A serving config is a specific endpoint on an engine which is used for querying.
#
# Having more than one serving config on an engine is helpful because each one can have different
# sets of controls attached to it.
#
# see https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1beta/latest/Google-Cloud-DiscoveryEngine-V1beta-ServingConfig
class ServingConfig < ApplicationRecord
  include DiscoveryEngineNameable

  # Tracks what this serving config is used for
  enum :use_case, {
    # Used for actual public search on GOV.UK, for example the default serving config or any
    # additional serving configs used for AB tests
    live: 0,
    # Used by search administrators for testing purposes, for example to try out a new control
    # before adding it to a live serving config
    preview: 1,
    # Used internally, can only be modified programatically (not through the Search Admin UI)
    system: 2,
  }, validate: true

  # Don't allow changing remote_resource_id after creation
  attr_readonly :remote_resource_id

  has_many :control_attachments, dependent: :destroy
  has_many :controls, through: :control_attachments
  accepts_nested_attributes_for :control_attachments, allow_destroy: true

  validates :display_name, presence: true
  validates :remote_resource_id, presence: true, uniqueness: true

  # A URL to preview this serving config on Finder Frontend
  def preview_url
    FinderFrontendSearch.new(
      keywords: "example search",
      debug_serving_config: remote_resource_id,
    ).url
  end
end
