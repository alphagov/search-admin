FactoryBot.define do
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
