# Adjustments allow search administrators to override how the search engine ranks results.
#
# An adjustment applies to any document that matches its `filter_expression`, and can be one of two kinds:
#   - `boost`: increases or decreases the rank of matching documents by a given `boost_factor`
#   - `filter`: removes matching documents from the search results entirely
#
# See https://cloud.google.com/generative-ai-app-builder/docs/filter-search-metadata for more
# information on the `filter_expression` syntax.
class Adjustment < ApplicationRecord
  # The range of permissible boost factor values
  BOOST_FACTOR_RANGE = -1.0..1.0

  include DiscoveryEngineSyncable
  discovery_engine_syncable as: DiscoveryEngine::Control

  enum :kind, { filter: 0, boost: 1 }, suffix: true, validate: true

  validates :name, presence: true
  validates :filter_expression, presence: true
  validates :boost_factor, numericality: { in: BOOST_FACTOR_RANGE, other_than: 0 }, if: :boost_kind?
  validates :boost_factor, absence: true, unless: :boost_kind?

  # The action attributes for the corresponding `DiscoveryEngine::Control`.
  def control_action
    if boost_kind?
      {
        boost_action: {
          boost: boost_factor,
          filter: filter_expression,
          data_store: discovery_engine_datastore,
        },
      }
    elsif filter_kind?
      {
        filter_action: {
          filter: filter_expression,
          data_store: discovery_engine_datastore,
        },
      }
    end
  end

private

  # The datastore whose documents the corresponding `DiscoveryEngine::Control` will affect. We only
  # use a single datastore in our architecture, so this will always be the same as set by the app's
  # configuration.
  def discovery_engine_datastore
    Rails.configuration.discovery_engine_datastore
  end
end
