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
  delegated_type :action, types: %w[Control::BoostAction Control::FilterAction], dependent: :destroy
  accepts_nested_attributes_for :action, update_only: true

  validates :display_name, presence: true
end
