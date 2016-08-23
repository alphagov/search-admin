class ElasticSearchRecommendedLink
  delegate :format, to: :recommended_link

  def initialize(recommended_link)
    @recommended_link = recommended_link
  end

  def header
    {
      index: {
        _id: id,
        _type: format
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
      format: format,
      indexable_content: @recommended_link.keywords
    }
  end

  def id
    link
  end

  def format
    if URI(@recommended_link.link).host.downcase == "www.gov.uk"
      'inside-government-link'
    else
      'recommended-link'
    end
  end

private

  def link
    @recommended_link.link
  end
end
