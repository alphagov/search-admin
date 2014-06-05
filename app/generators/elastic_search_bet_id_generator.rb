class ElasticSearchBetIDGenerator
  def self.generate(query, match_type)
    "#{query}-#{match_type}"
  end
end
