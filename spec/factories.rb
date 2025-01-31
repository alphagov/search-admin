FactoryBot.define do
  factory :control do
    display_name { "Control" }

    action factory: :control_boost_action

    trait :with_boost_action do
      action factory: :control_boost_action
    end

    trait :with_filter_action do
      action factory: :control_filter_action
    end
  end

  factory :control_boost_action, class: Control::BoostAction do
    filter_expression { 'link: ANY("/example")' }
    boost_factor { 0.13 }
  end

  factory :control_filter_action, class: Control::FilterAction do
    filter_expression { 'link: ANY("/example")' }
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
