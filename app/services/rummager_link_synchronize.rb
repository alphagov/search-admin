class RummagerLinkSynchronize
  def initialize(recommended_link)
    @recommended_link = recommended_link
    @client = SearchAdmin.services(:rummager_index_mainstream)
  end

  def put
    es_doc = ElasticSearchRecommendedLink.new(recommended_link)
    client.add_document("edition", es_doc.id, es_doc.details)
  end

  def delete
    client.delete_document("edition", recommended_link.link)
  end

  def self.put(recommended_link)
    self.new(recommended_link).put
  end

  def self.delete(recommended_link)
    self.new(recommended_link).delete
  end

private

  attr_reader :client, :recommended_link
end
