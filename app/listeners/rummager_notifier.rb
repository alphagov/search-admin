class RummagerNotifier
  def self.call(best_bet_data)
    best_bet_data.symbolize_keys!

    query = best_bet_data[:query]
    match_type = best_bet_data[:match_type]

    query_field = "#{match_type}_query".to_sym

    es_doc = {
      query_field => query,
      details: {
        best_bets: [],
        worst_bets: []
      }
    }

    BestBet.where(query: query, match_type: match_type).order([:position, :link]).each do |best_bet|
      if best_bet.position
        es_doc[:details][:best_bets] << {link: best_bet.link, position: best_bet.position}
      else
        es_doc[:details][:worst_bets] << {link: best_bet.link}
      end
    end

    SearchAdmin.services(:rummager_index).add(es_doc)
  end
end
