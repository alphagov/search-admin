Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect(
    "elastic_search_bet_id_generator" => "ElasticSearchBetIDGenerator",
  )
end
