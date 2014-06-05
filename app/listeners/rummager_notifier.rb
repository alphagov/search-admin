class RummagerNotifier
  def self.call(changed_query_match_type_pairs)
    changed_query_match_type_pairs.each do |(query, match_type)|
      update_elasticsearch(query, match_type)
    end
  end

private

  def self.update_elasticsearch(query_string, match_type)
    if query = Query.where(query: query_string, match_type: match_type).first
      es_doc = ElasticSearchBet.new(query, include_id_and_type_in_body: true)
      SearchAdmin.services(:rummager_index).add(es_doc.body)
    else
      es_doc_id = ElasticSearchBetIDGenerator.generate(query_string, match_type)
      SearchAdmin.services(:rummager_index).delete(es_doc_id, type: 'best_bet')
    end
  end
end
