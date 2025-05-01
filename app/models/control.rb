class Control
  # The IDs of all serving configs that a control should be applied to by default, unless explicitly
  # specified otherwise.
  ALL_SERVING_CONFIGS = %w[default_search variant_search].freeze

  include DiscoveryEngineNameable

  # Returns all currently active controls, both static and dynamic
  def self.all
    [
      # Static controls defined in config/static_controls.yml
      *static,
      # One control per active Best Bet
      *BestBets.active.map(&:control),
      # One control for all blocked links
      BlockedLink.control,
    ].compact_blank
  end

  # Returns all static controls defined in config/static_controls.yml
  def self.static
    @static ||= Rails.application.config_for(:static_controls).map do |id, values|
      new(id, values[:properties], serving_configs: values[:serving_configs])
    end
  end

  # Initializes a control with a given remote resource ID and properties, and an optional list of
  # serving configs it should be applied to. If no serving configs are provided, the control will be
  # applied to all serving configs.
  def initialize(remote_resource_id, properties, serving_configs: nil)
    @remote_resource_id = remote_resource_id
    @properties = properties
    @serving_configs = serving_configs || ALL_SERVING_CONFIGS
  end

  attr_reader :remote_resource_id, :properties, :serving_configs

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
end
