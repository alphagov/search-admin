# Tasks to seed the app's production environments, for example creating records for pre-existing
# resources.
namespace :bootstrap do
  # As of Feb 2025, the Ruby client for Discovery Engine does not allow full lifecycle management
  # of serving config resources (only updating existing ones) - so we created the following serving
  # configs in Terraform in `govuk-infrastructure`.
  #
  # see https://github.com/alphagov/govuk-infrastructure/pull/1680
  desc "Creates ServingConfig records for resources already created in Terraform"
  task seed_serving_configs: :environment do
    ServingConfig.create!(
      display_name: "Default",
      description: "The live serving config used by GOV.UK site search",
      remote_resource_id: ServingConfig::DEFAULT_REMOTE_RESOURCE_ID,
      users_can_assign_controls: true,
    )
    ServingConfig.create!(
      display_name: "Preview",
      description: "A preview serving config to test out changes",
      remote_resource_id: "govuk_preview",
      users_can_assign_controls: true,
    )
    ServingConfig.create!(
      display_name: "Raw",
      description: "A serving config without any controls applied",
      remote_resource_id: "govuk_raw",
      users_can_assign_controls: false,
    )
  end
end
