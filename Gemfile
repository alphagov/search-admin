source "https://rubygems.org"

gem "rails", "6.1.4.6"

gem "bootsnap"
gem "generic_form_builder"
gem "mysql2"
gem "sassc-rails"
gem "sidekiq-scheduler"
gem "uglifier"

# GDS managed gems
gem "gds-api-adapters"
gem "gds-sso"
gem "govuk_admin_template"
gem "govuk_app_config"
gem "govuk_publishing_components"
gem "govuk_sidekiq"
gem "mail-notify"
gem "plek"

group :test do
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "govuk-content-schema-test-helpers"
  gem "simplecov"
  gem "webmock"
end

group :test, :development do
  gem "listen"
  gem "pry-byebug"
  gem "rails-controller-testing" # support `expect(..).to render_template(..)` for rails >= 5.0
  gem "rspec-rails"
  gem "rubocop-govuk"
end
