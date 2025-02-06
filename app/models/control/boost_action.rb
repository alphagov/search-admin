# Represents a boost action for a `Control`.
#
# Allows changing the ranking of search results for documents matching a given filter expression, by
# applying a positive (promotion) or negative (demotion) boost factor to them.
#
# For example, we could:
# - promote important content types
# - make content that is less relevant to users to appear lower in search results
#
# see https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1/latest/Google-Cloud-DiscoveryEngine-V1-Control-BoostAction
class Control::BoostAction < ApplicationRecord
  include Control::Actionable

  # The range of permissible boost values, from maximum demotion to maximum promotion.
  BOOST_FACTOR_RANGE = -1.0..1.0

  validates :filter_expression, presence: true
  validates :boost_factor, numericality: { in: BOOST_FACTOR_RANGE, other_than: 0 }

  # Returns a representation of this boost as part of a Discovery Engine control resource
  def to_discovery_engine_control_action
    {
      boost_action: {
        filter: filter_expression,
        boost: boost_factor,
        data_store: DataStore.default.name,
      },
    }
  end
end
