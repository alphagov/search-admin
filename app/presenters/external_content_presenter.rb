class ExternalContentPresenter
  def initialize(recommended_link)
    @recommended_link = recommended_link
  end

  def present_for_publishing_api
    {
      description: @recommended_link.description,
      details: {
        hidden_search_terms:,
        url: @recommended_link.link,
      },
      document_type: "external_content",
      publishing_app: "search-admin",
      schema_name: "external_content",
      title: @recommended_link.title,
      update_type: "minor",
    }
  end

private

  def hidden_search_terms
    [@recommended_link.keywords].compact
  end
end
