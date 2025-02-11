FactoryBot.define do
  # Unlike fixtures, record instances created through FactoryBot go through the full Rails callback
  # lifecycle on creation. That is often desirable, but not in the case of our models using the
  # `RemoteSynchronizable` concern to create counterparts on remote APIs automatically whenever you
  # create a new record.
  #
  # This trait sets the `skip_remote_synchronization_on_create` flag to true on records created
  # through factories that include it, so that this behaviour is skipped.
  #
  # If you _do_ want to specifically test remote synchronization on a record, you can override this
  # manually when you build your model using `FactoryBot.build`:
  # ```ruby
  # build(:my_model, skip_remote_synchronization_on_create: false)
  # ```
  trait :remote_synchronizable do
    skip_remote_synchronization_on_create { true }
  end

  factory :control, traits: %i[remote_synchronizable] do
    display_name { "Control" }
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

  factory :user do
    factory :admin_user do
      permissions { %w[admin] }
    end
    permissions { %w[signin] }
  end
end
