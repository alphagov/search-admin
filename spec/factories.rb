FactoryGirl.define do
  factory :best_bet do
    query "tax"
    link "/death-and-taxes"
  end

  factory :user do
    permissions { ["signin"] }
  end
end
