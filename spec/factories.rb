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

  factory :user do
    permissions { ["signin"] }
  end
end
