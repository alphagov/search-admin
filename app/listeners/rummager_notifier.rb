class RummagerNotifier
  def self.call(best_bet_data)
    best_bet_data.symbolize_keys!
    query = best_bet_data[:query]
    match_type = best_bet_data[:match_type]
    original_attributes = best_bet_data[:original]
    if original_attributes.nil?
      original_query = query
      original_match_type = match_type
    else
      original_attributes.symbolize_keys!
      original_query = original_attributes[:query]
      original_match_type = original_attributes[:match_type]
    end

    if query != original_query || match_type != original_match_type
      update_elasticsearch(original_query, original_match_type)
    end
    update_elasticsearch(query, match_type)
  end

  def self.update_elasticsearch(query, match_type)
    matching_bets = BestBet.where(query: query, match_type: match_type)

    if matching_bets.any?
      es_doc = ElasticSearchBestBet.from_matching_bets(matching_bets, include_id_and_type_in_body: true)
      SearchAdmin.services(:rummager_index).add(es_doc.body)
    else
      es_doc = ElasticSearchBestBet.new(query, match_type, nil)
      SearchAdmin.services(:rummager_index).delete(es_doc.id, type: 'best_bet')
    end
  end
end
