# Quieten warnings from external dependencies
# This helps reduce the noise in the logs caused by govuk_frontend still supporting legacy SassC.
# TODO: Remove this once govuk_frontend no longer supports legacy SassC (slated for 6.0).
Rails.application.config.dartsass.build_options << " --quiet-deps"
