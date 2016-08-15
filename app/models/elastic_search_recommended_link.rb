class ElasticSearchRecommendedLink
  # _id and _type fields should be included in the body when
  # being sent via Rummager but not when being sent directly to ElasticSearch.
  #
  # TODO: Alter Rummager's endpoint to take an optional id and type param
  # in place of this functionality.
  def initialize(recommended_link, include_id_and_type_in_body: false)
    @recommended_link = recommended_link
    @include_id_and_type_in_body = include_id_and_type_in_body
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
    es_body = {
      link: link,
      details: details.to_json
    }

    if @include_id_and_type_in_body
      es_body.merge(
        _id: id,
        _type: type
      )
    else
      es_body
    end
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
