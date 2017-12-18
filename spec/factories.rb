FactoryGirl.define do
  sequence :numeric_position do |n|
    n
  end

  factory :bet do
    link "/death-and-taxes"

    trait(:worst) {
      is_best false
    }

    trait(:best) {
      is_best true
      position { generate :numeric_position }
    }

    user
  end

  factory :query do
    query "tax"
    match_type "exact"

    trait :with_best_bet do
      after(:create) do |query|
        create(:bet, :best, query: query)
      end
    end
  end

  factory :recommended_link do
    title "Tax online"
    link "https://www.tax.service.gov.uk/"
    description "File your self assessment online."
    keywords "tax, self assessment, hmrc"
    content_id { SecureRandom.uuid }
  end

  factory :user do
    permissions { ["signin"] }
  end
end
