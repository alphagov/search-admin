# Represents a serving config(uration) on Discovery Engine.
#
# A serving config is a specific endpoint on an engine which is used for querying.
#
# Having more than one serving config on an engine is helpful because each one can have different
# sets of controls attached to it.
#
# see https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1beta/latest/Google-Cloud-DiscoveryEngine-V1beta-ServingConfig
class ServingConfig < ApplicationRecord
  # Defines which use cases of serving configs can be edited by users through the UI
  USER_EDITABLE_USE_CASES = %w[live preview].freeze

  include DiscoveryEngineNameable

  include RemoteSynchronizable
  self.remote_synchronizable_client_class = DiscoveryEngine::ServingConfigClient

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

  validates :display_name, presence: true
  validates :remote_resource_id, presence: true, uniqueness: true

  # Returns all serving configs that can be edited by users through the UI
  def self.user_editable
    where(use_case: USER_EDITABLE_USE_CASES)
  end

  # Returns whether this serving config can be edited by users through the UI
  def user_editable?
    use_case.in?(USER_EDITABLE_USE_CASES)
  end

  # A URL to preview this serving config on Finder Frontend
  def preview_url
    FinderFrontendSearch.new(
      keywords: "example search",
      debug_serving_config: remote_resource_id,
    ).url
  end

  # The parent of the serving config on Discovery Engine (always the default engine)
  def parent
    Engine.default
  end

  # Returns a representation of this ServingConfig as a Discovery Engine serving config resource
  def to_discovery_engine_serving_config
    {
      name:,
      boost_control_ids: controls.control_boost_actions.map(&:remote_resource_id),
      filter_control_ids: controls.control_filter_actions.map(&:remote_resource_id),
    }
  end
end
