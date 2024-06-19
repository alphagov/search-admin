FactoryBot.define do
  factory :control do
    name { "Control" }
    boost_amount { 0.5 }
    filter { 'document_type: ANY("press_release")' }
    active { true }
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
