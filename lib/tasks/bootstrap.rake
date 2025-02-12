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
      use_case: :live,
      display_name: "Default",
      description: "Used by live GOV.UK site search",
      remote_resource_id: "govuk_default",
    )
    ServingConfig.create!(
      use_case: :preview,
      display_name: "Preview",
      description: "A preview serving config to test out changes",
      remote_resource_id: "govuk_preview",
    )
    ServingConfig.create!(
      use_case: :system,
      display_name: "Raw",
      description: "A serving config without any controls applied",
      remote_resource_id: "govuk_raw",
    )
  end
end
