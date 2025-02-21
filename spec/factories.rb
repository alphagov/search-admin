FactoryBot.define do
  factory :control do
    sequence(:display_name) { "Control #{it}" }

    comment { "This is a nice control." }

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

  factory :serving_config do
    sequence(:display_name) { "Serving config #{it}" }
    sequence(:remote_resource_id) { "serving-config-#{it}" }

    use_case { :live }
    description { "A serving configuration" }
  end

  factory :user do
    factory :admin_user do
      permissions { %w[admin] }
    end
    permissions { %w[signin] }
  end
end
