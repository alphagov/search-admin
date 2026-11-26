# Add the component guide stylesheet to the dartsass build so we can use the component guide (without this,
# Sprockets will try and use the legacy SassC compiler to build them which we no longer include in this app)
APP_STYLESHEETS = {
  "application.scss" => "application.css",
}.freeze

all_stylesheets = APP_STYLESHEETS.merge(GovukPublishingComponents::Config.component_guide_stylesheet)
Rails.application.config.dartsass.builds = all_stylesheets

# Quieten warnings from external dependencies
# This helps reduce the noise in the logs caused by govuk_frontend still supporting legacy SassC.
# TODO: Remove this once govuk_frontend no longer supports legacy SassC (slated for 6.0).
Rails.application.config.dartsass.build_options << " --quiet-deps"
