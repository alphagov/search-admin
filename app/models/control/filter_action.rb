# Represents a filter action for a `Control`.
#
# Allows us to remove content matching a given filter expression from search results entirely.
#
# For example, we could temporarily remove content that has been accidentally published while the
# problem is fixed upstream.
#
# see https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1/latest/Google-Cloud-DiscoveryEngine-V1-Control-FilterAction
class Control::FilterAction < ApplicationRecord
  include Control::Actionable

  validates :filter_expression, presence: true
end
