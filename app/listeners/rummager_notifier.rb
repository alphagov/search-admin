class RummagerNotifier
  def self.update_elasticsearch(query, action)
    if action == :delete || (action == :update_bets && query.bets.empty?)
      es_doc_id = ElasticSearchBetIDGenerator.generate(query.query, query.match_type)
      Services.rummager_index_metasearch.delete_document("best_bet", CGI.escape(es_doc_id))
    elsif query.bets.any? # don't create ES entry until query has some bets
      es_doc = ElasticSearchBet.new(query)
      Services.rummager_index_metasearch.add_document(es_doc.type, es_doc.id, es_doc.body)
    end
  end
end
