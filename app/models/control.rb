class Control
  STATIC_CONTROLS = {
    foo: { bar: "baz" },
  }.freeze

  include DiscoveryEngineNameable

  def self.all
    {
      **STATIC_CONTROLS,
      **BestBet.active.to_h { ["best-bet-#{it.id}", it.to_discovery_engine_control_properties] },
      blocked_links: BlockedLink.to_discovery_engine_control_properties,
    }.map { |remote_resource_id, properties| new(remote_resource_id, properties) }.compact_blank
  end

  def initialize(remote_resource_id, properties)
    @remote_resource_id = remote_resource_id
    @properties = properties
  end

  delegate :blank?, :present?, to: :properties

  def to_discovery_engine_control
    {
      name:,
      display_name:,
      **properties,
      solution_type: Google::Cloud::DiscoveryEngine::V1::SolutionType::SOLUTION_TYPE_SEARCH,
      # Trip hazard: despite the plural name, this expects _one_ use case in an array
      use_cases: [Google::Cloud::DiscoveryEngine::V1::SearchUseCase::SEARCH_USE_CASE_SEARCH],
    }
  end

  def display_name
    "#{remote_resource_id} (managed by Search Admin)"
  end

  def parent
    Engine.default
  end

private

  attr_reader :remote_resource_id, :properties
end
