# Represents a Control resource on Discovery Engine.
#
# Each control is a single, specific customisation of search engine behaviour that can affect how
# a query is processed, or how results are returned.
#
# There are several different kinds of actions a control can have, such as filtering or boosting
# certain results, which we model as an `action` delegated type (see `types` argument to
# `delegated_type :action`).
#
# see
# https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1/latest/Google-Cloud-DiscoveryEngine-V1-Control
class Control < ApplicationRecord
  include DiscoveryEngineNameable

  include RemoteSynchronizable
  self.remote_synchronizable_client_class = DiscoveryEngine::ControlClient

  delegated_type :action, types: %w[Control::BoostAction Control::FilterAction], dependent: :destroy
  accepts_nested_attributes_for :action, update_only: true

  validates :display_name, presence: true
  validates :comment, presence: true

  # Returns a representation of this Control as a Discovery Engine control resource
  def to_discovery_engine_control
    {
      name:,
      display_name:,
      **action.to_discovery_engine_control_action,
      solution_type: Google::Cloud::DiscoveryEngine::V1::SolutionType::SOLUTION_TYPE_SEARCH,
      # Trip hazard: despite the plural name, this expects _one_ use case in an array
      use_cases: [Google::Cloud::DiscoveryEngine::V1::SearchUseCase::SEARCH_USE_CASE_SEARCH],
    }
  end

  # The parent of the control on Discovery Engine (always the default engine)
  def parent
    Engine.default
  end

  # The ID of the resource on Discovery Engine
  def remote_resource_id
    "search-admin-#{id}"
  end
end
