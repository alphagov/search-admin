FactoryGirl.define do
  factory :best_bet do
    query "tax"
    link "/death-and-taxes"
    match_type "exact"
    position 1
    user
  end

  factory :user do
    permissions { ["signin"] }
  end
end
