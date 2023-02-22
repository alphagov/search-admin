class ElasticSearchRecommendedLink
  delegate :format, :link, :title, :description, to: :recommended_link

  def initialize(recommended_link)
    @recommended_link = recommended_link
  end

  def body
    {
      link:,
      details: details.to_json,
    }
  end

  def details
    {
      title:,
      link:,
      description:,
      format:,
      indexable_content:,
    }
  end

  def id
    link
  end

  def indexable_content
    recommended_link.keywords
  end

private

  attr_reader :recommended_link
end
