module RummagerLinkSynchronize
  def self.put(recommended_link, client: self.client)
    es_doc = ElasticSearchRecommendedLink.new(recommended_link)
    client.add_document("edition", es_doc.id, es_doc.details)
  end

  def self.delete(recommended_link, client: self.client)
    client.delete_document("edition", recommended_link.link)
  end

  def self.client
    SearchAdmin.services(:rummager_index_mainstream)
  end
end
