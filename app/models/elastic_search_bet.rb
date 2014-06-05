class ElasticSearchBet
  # _id and _type fields should be included in the body when
  # being sent via Rummager but not when being sent directly to ElasticSearch.
  #
  # TODO: Alter Rummager's endpoint to take an optional id and type param
  # in place of this functionality.
  def initialize(query, include_id_and_type_in_body: false)
    @query = query
    @include_id_and_type_in_body = include_id_and_type_in_body
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
    es_body = {
      query_field => query_string,
      details: details.to_json
    }

    if @include_id_and_type_in_body
      es_body.merge(
        _id: id,
        _type: type
      )
    else
      es_body
    end
  end

  def id
    "#{query_string}-#{match_type}"
  end

private

  def query_field
    "#{match_type}_query".to_sym
  end

  def type
    'best_bet'
  end

  def query_string
    @query.query
  end

  def match_type
    @query.match_type
  end

  def details
    {
      best_bets: best_bets.map {|bet| {link: bet.link, position: bet.position} },
      worst_bets: worst_bets.map {|bet| {link: bet.link} }
    }
  end

  def best_bets
    @query.best_bets.sort_by {|b| [b.position, b.link] }
  end

  def worst_bets
    @query.worst_bets.sort_by(&:link)
  end
end
