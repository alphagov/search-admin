class ElasticSearchBestBet
  def self.from_matching_bets(bets)
    if bets_not_matching?(bets)
      raise ArgumentError.new("Bets must have matching query and match_type")
    end

    representative_bet = bets.first

    query = representative_bet.query
    match_type = representative_bet.match_type

    ordered_bets = bets.sort_by {|b| [b.position || 0, b.link || '']}
    positive_bets, negative_bets = ordered_bets.partition(&:position)
    details = {
      best_bets: positive_bets.map {|bet| {link: bet.link, position: bet.position} },
      worst_bets: negative_bets.map {|bet| {link: bet.link} }
    }

    new(query, match_type, details)
  end

  def initialize(query, match_type, details)
    @query = query
    @match_type = match_type
    @details = details
  end

  def header
    {
      index: {
        _id: id,
        _type: type
      }
    }
  end

  def body
    {
      _id: id,
      _type: type,
      query_field => @query,
      details: @details.to_json
    }
  end

private

  def id
    "#{@query}-#{@match_type}"
  end

  def query_field
    "#{@match_type}_query".to_sym
  end

  def type
    'best_bet'
  end

  def self.bets_not_matching?(bets)
    bets.map {|b| [b.query, b.match_type] }.uniq.count > 1
  end
end
