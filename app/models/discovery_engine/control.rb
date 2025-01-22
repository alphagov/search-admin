module DiscoveryEngine
  # Represents a `Control` resource on Discovery Engine.
  #
  # Each control is a single, specific customisation of search engine behaviour that can affect how
  # a query is processed, or how results are returned.
  #
  # Several different models in Search Admin map to Controls in Discovery Engine (such as
  # `Adjustment`), so this class operates on a duck typed "controllable".
  #
  # see
  # https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1/latest/Google-Cloud-DiscoveryEngine-V1-Control
  class Control
    def initialize(
      controllable,
      client: ::Google::Cloud::DiscoveryEngine.control_service(version: :v1)
    )
      @controllable = controllable
      @client = client
    end

    # Create a new Control resource on Discovery Engine.
    def create!
      client.create_control(control:, control_id: id, parent: parent_name)
    rescue Google::Cloud::Error => e
      raise Error, e
    end

    # Update an existing Control resource on Discovery Engine.
    def update!
      client.update_control(control:)
    rescue Google::Cloud::Error => e
      raise Error, e
    end

    # Delete an existing Control resource on Discovery Engine.
    def delete!
      client.delete_control(name:)
    rescue Google::Cloud::Error => e
      raise Error, e
    end

    # A unique ID used in Discovery Engine to identify the control. Becomes part of the fully
    # qualified name after remote creation.
    def id
      sprintf("search-admin-%s-%s", controllable.model_name.param_key, controllable.id)
    end

    # The fully qualified name (path) of the control in Discovery Engine.
    def name
      [parent_name, "/controls/", id].join
    end

  private

    attr_reader :controllable, :client

    # The combined parameters for the Control resource to be created or updated.
    def control
      {
        name:,
        display_name: controllable.name,
        **controllable.control_action,
        solution_type: Google::Cloud::DiscoveryEngine::V1::SolutionType::SOLUTION_TYPE_SEARCH,
        # Trip hazard: despite the plural name, this expects _one_ use case in an array
        use_cases: [Google::Cloud::DiscoveryEngine::V1::SearchUseCase::SEARCH_USE_CASE_SEARCH],
      }
    end

    # Parent resource of the control, in our case always the main engine.
    def parent_name
      Rails.configuration.discovery_engine_engine
    end
  end
end
