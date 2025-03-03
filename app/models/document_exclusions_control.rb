# A filter control that removes all documents covered by document exclusions from search results.
class DocumentExclusionsControl
  include Singleton
  include DiscoveryEngineNameable

  def sync
    if active?
      client.create_or_update(self)
    else
      client.delete_if_exists(self)
    end
  end

  def active?
    DocumentExclusion.any?
  end

  def to_discovery_engine_control
    {
      name:,
      display_name: "Search Admin: Document Exclusions",
      filter_action: {
        filter: filter_expression,
        data_store: DataStore.default.name,
      },
      solution_type: Google::Cloud::DiscoveryEngine::V1::SolutionType::SOLUTION_TYPE_SEARCH,
      use_cases: [Google::Cloud::DiscoveryEngine::V1::SearchUseCase::SEARCH_USE_CASE_SEARCH],
    }
  end

  def discovery_engine_control_type
    :filter
  end

  def remote_resource_id
    "search-admin-document-exclusions"
  end

  def parent
    Engine.default
  end

private

  def resource_path_fragment
    "controls"
  end

  def filter_expression
    return nil unless active?

    excluded_links = DocumentExclusion.pluck(:link).map { "\"#{it}\"" }.join(", ")
    "NOT link: ANY(#{excluded_links})"
  end

  def client
    DiscoveryEngine::ControlClient.new
  end
end
