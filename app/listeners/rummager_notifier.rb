class RummagerNotifier
  def self.notify(changed_query_match_type_pairs)
    changed_query_match_type_pairs.each do |(query_string, match_type)|
      update_elasticsearch(query_string, match_type)
    end
  end

  def self.update_elasticsearch(query_string, match_type)
    query = Query.where(query: query_string, match_type: match_type).first

    if query && query.bets.any?
      es_doc = ElasticSearchBet.new(query)
      Services.rummager_index_metasearch.add_document(es_doc.type, es_doc.id, es_doc.body)
    else
      es_doc_id = ElasticSearchBetIDGenerator.generate(query_string, match_type)
      Services.rummager_index_metasearch.delete_document("best_bet", CGI.escape(es_doc_id))
    end
  end
end
