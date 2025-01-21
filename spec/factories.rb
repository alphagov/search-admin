FactoryBot.define do
  factory :boost_adjustment, class: Adjustment do
    kind { :boost }
    name { "Boost adjustment" }
    filter_expression { 'link: ANY("/example")' }
    boost_factor { 0.13 }
  end

  factory :filter_adjustment, class: Adjustment do
    kind { :filter }
    name { "Filter adjustment" }
    filter_expression { 'link: ANY("/example")' }
  end

  factory :recommended_link do
    title { "Tax online" }
    link { "https://www.tax.service.gov.uk/" }
    description { "File your self assessment online." }
    keywords { "tax, self assessment, hmrc" }
  end

  factory :user do
    factory :admin_user do
      permissions { %w[admin] }
    end
    permissions { %w[signin] }
  end
end
