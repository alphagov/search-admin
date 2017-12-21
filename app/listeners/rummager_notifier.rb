class RummagerNotifier
  def self.update_elasticsearch(query, action)
    if action == :delete || (action == :update_bets && query.bets.empty?)
      es_doc_id = ElasticSearchBetIDGenerator.generate(query.query, query.match_type)
      Services.rummager.delete_document(CGI.escape(es_doc_id))
    elsif query.bets.any? # don't create ES entry until query has some bets
      es_doc = ElasticSearchBet.new(query)
      Services.rummager.add_document(es_doc.id, es_doc.body, 'metasearch')
    end
  end
end
