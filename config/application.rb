require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SearchAdmin
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.action_view.default_form_builder = GenericFormBuilder
    config.action_view.field_error_proc = proc { |html_tag, _| html_tag }

    # Using a sass css compressor causes a scss file to be processed twice
    # (once to build, once to compress) which breaks the usage of "unquote"
    # to use CSS that has same function names as SCSS such as max.
    # https://github.com/alphagov/govuk-frontend/issues/1350
    config.assets.css_compressor = nil

    # Enable per-form CSRF tokens. Previous versions had false.
    config.action_controller.per_form_csrf_tokens = false

    # Enable origin-checking CSRF mitigation. Previous versions had false.
    config.action_controller.forgery_protection_origin_check = false

    # Make Ruby 2.4 preserve the timezone of the receiver when calling `to_time`.
    # Previous versions had false.
    ActiveSupport.to_time_preserves_timezone = false

    # Require `belongs_to` associations by default. Previous versions had false.
    config.active_record.belongs_to_required_by_default = false
  end
end
