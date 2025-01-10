# Represents a Control in Discovery Engine
# see https://cloud.google.com/generative-ai-app-builder/docs/reference/rest/v1/projects.locations.collections.dataStores.controls
class DiscoveryEngineControl < ApplicationRecord
  # The allowed range for boosting in Discovery Engine, where -1.0 is maximum demotion, 0.0 is no
  # change, and 1.0 is maximum promotion.
  DISCOVERY_ENGINE_BOOST_RANGE = (-1.0..1.0).freeze

  enum :action, { filter: 0, boost: 1 }, suffix: true

  validates :name, presence: true
  validates :action, presence: true
  validates :filter, presence: true

  validates :boost_amount, numericality: { in: DISCOVERY_ENGINE_BOOST_RANGE }, if: :boost_action?
  validates :boost_amount, absence: true, unless: :boost_action?
end
