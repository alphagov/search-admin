FactoryGirl.define do
  factory :best_bet do
    query "tax"
  end

  factory :user do
    permissions { ["signin"] }
  end
end
