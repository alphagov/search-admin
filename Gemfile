source "https://rubygems.org"

gem "rails", "6.0.3.2"

gem "bootsnap", "~> 1.4"
gem "generic_form_builder", "~> 0.13.1"
gem "mysql2", "~> 0.4.5"
gem "sass-rails", "~> 5.1.0"
gem "sidekiq-scheduler", "~> 3.0"
gem "uglifier", "~> 4.2.0"

# GDS managed gems
gem "gds-api-adapters", "~> 67.0.0"
gem "gds-sso", "~> 15.0.0"
gem "govuk_admin_template"
gem "govuk_app_config", "~> 2.2.0"
gem "govuk_publishing_components", "~> 21.56.2"
gem "govuk_sidekiq", "~> 3.0"
gem "mail-notify"
gem "plek", "~> 4.0.0"

group :test do
  gem "cucumber-rails", require: false
  gem "database_cleaner", "~> 1.8.5"
  gem "factory_bot_rails", "~> 6"
  gem "govuk-content-schema-test-helpers", "~> 1.6.1"
  gem "webmock", "~> 3.8.3"
end

group :test, :development do
  gem "listen", "~> 3.2"
  gem "pry-byebug"
  gem "rails-controller-testing" # support `expect(..).to render_template(..)` for rails >= 5.0
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop-govuk"
end
