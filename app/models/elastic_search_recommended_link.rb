class ElasticSearchRecommendedLink
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
    link
  end

private

  def type
    if @recommended_link.link.start_with?("https://www.gov.uk")
      'inside-government-link'
    else
      'recommended-link'
    end
  end

  def link
    @recommended_link.link
  end
end
