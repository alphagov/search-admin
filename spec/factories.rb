FactoryBot.define do
  factory :discovery_engine_control do
    active { true }
    filter { 'link: ANY("/example")' }

    factory :discovery_engine_filter_control do
      name { "Filter control" }
      action { :filter }
    end

    factory :discovery_engine_boost_control do
      name { "Boost control" }
      action { :boost }
      boost_amount { 0.13 }
    end
  end

  factory :recommended_link do
    title { "Tax online" }
    link { "https://www.tax.service.gov.uk/" }
    description { "File your self assessment online." }
    keywords { "tax, self assessment, hmrc" }
    content_id { SecureRandom.uuid }
  end

  factory :user do
    factory :admin_user do
      permissions { %w[admin] }
    end
    permissions { %w[signin] }
  end
end
