FactoryBot.define do
  factory :boost do
    filter { "foo: ANY('#{SecureRandom.uuid}')" }
    boost_amount { Random.rand(-1.0..1.0).round(2) }
    created_by { create(:user) }
    updated_by { create(:user) }
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
