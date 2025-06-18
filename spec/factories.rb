FactoryBot.define do
  factory :completion_denylist_entry do
    phrase { "tea time" }
    match_type { :contains }
    category { :general }
    comment { "The tea time alarm has been suspended until further notice" }
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
