FactoryGirl.define do
  factory :bet do
    link "/death-and-taxes"

    trait(:worst) {
      is_best false
    }

    trait(:best) {
      is_best true
      sequence(:position) { |n| }
    }

    user
  end

  factory :query do
    query "tax"
    match_type "exact"

    after(:create) do |query|
      create(:bet, :best, query: query)
    end
  end

  factory :user do
    permissions { ["signin"] }
  end
end
