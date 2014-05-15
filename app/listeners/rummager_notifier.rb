class RummagerNotifier
  def self.call(best_bet_data)
    best_bet_data.symbolize_keys!

    matching_bets = BestBet.where(query: best_bet_data[:query], match_type: best_bet_data[:match_type])

    if matching_bets.any?
      es_doc = ElasticSearchBestBet.from_matching_bets(matching_bets, include_id_and_type_in_body: true)
      SearchAdmin.services(:rummager_index).add(es_doc.body)
    else
      es_doc = ElasticSearchBestBet.new(best_bet_data[:query], best_bet_data[:match_type], nil)
      SearchAdmin.services(:rummager_index).delete(es_doc.id, type: 'best_bet')
    end
  end
end
