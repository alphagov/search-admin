namespace :bootstrap do
  # As of Feb 2025, the Discovery Engine Ruby client does not yet support creating or deleting
  # serving configs (due to those API endpoints only being on the alpha API, which the Ruby client
  # does not include).
  #
  # Until this is supported, and we add the ability to create/delete serving configs to Search
  # Admin, we will operate with a fixed set of serving configs as created by this task.
  #
  # These serving configs have been set up through GOV.UK Infrastructure:
  # see https://github.com/alphagov/govuk-infrastructure/pull/1680
  desc "Create the initial set of ServingConfig records"
  task import_initial_serving_configs: :environment do
    ServingConfig.create!(
      discovery_engine_id: ServingConfig::DEFAULT_SERVING_CONFIG_ID,
      display_name: "GOV.UK Default",
      comment: "The default serving config used for live search",
      can_have_attached_controls: true,
    )

    ServingConfig.create!(
      discovery_engine_id: "govuk_preview",
      display_name: "Preview",
      comment: "A preview serving config used for trying out new controls without affecting live search",
      can_have_attached_controls: true,
    )

    ServingConfig.create!(
      discovery_engine_id: "govuk_raw",
      display_name: "Raw",
      comment: 'An empty serving config used to test the "raw" engine without any controls',
      can_have_attached_controls: false,
    )
  end
end
