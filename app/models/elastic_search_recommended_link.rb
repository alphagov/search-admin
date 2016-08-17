class ElasticSearchRecommendedLink
  # _id and _type fields should be included in the body when
  # being sent via Rummager but not when being sent directly to ElasticSearch.
  #
  # TODO: Alter Rummager's endpoint to take an optional id and type param
  # in place of this functionality.
  def initialize(recommended_link)
    @recommended_link = recommended_link
  end

  def header
    {
      index: {
        _id: id,
        _type: type
      }
    }
  end

  def body
    {
      link: link,
      details: details.to_json
    }
  end

  def details
    {
      title: @recommended_link.title,
      link: @recommended_link.link,
      description: @recommended_link.description,
      format: type,
      indexable_content: @recommended_link.keywords
    }
  end

  def id
    ElasticSearchRecommendedLinkIDGenerator.generate(link)
  end

private

  def type
    'recommended-link'
  end

  def link
    @recommended_link.link
  end
end
