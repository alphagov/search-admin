class ElasticSearchBet
  def initialize(query)
    @query = query
  end

  def header
    {
      index: {
        _id: id,
        _type: type,
      },
    }
  end

  def body
    {
      query_field => query_string,
      details: details.to_json,
    }
  end

  def id
    ElasticSearchBetIDGenerator.generate(query_string, match_type)
  end

  def type
    "best_bet"
  end

private

  def query_field
    "#{match_type}_query".to_sym
  end

  def query_string
    @query.query
  end

  def match_type
    @query.match_type
  end

  def details
    {
      best_bets: best_bets.map { |bet| { link: bet.link, position: bet.position } },
      worst_bets: worst_bets.map { |bet| { link: bet.link } },
    }
  end

  def best_bets
    @query.best_bets.sort_by { |b| [b.position, b.link] }
  end

  def worst_bets
    @query.worst_bets.sort_by(&:link)
  end
end
