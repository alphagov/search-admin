source "https://rubygems.org"

gem "rails", "7.1.3.2"

gem "bootsnap", require: false
gem "dartsass-rails"
gem "mysql2"
gem "sentry-sidekiq"
gem "sprockets-rails"

# GDS managed gems
gem "gds-api-adapters"
gem "gds-sso"
gem "govuk_admin_template"
gem "govuk_app_config"
gem "govuk_publishing_components"
gem "govuk_sidekiq"
gem "mail-notify"
gem "plek"

# X-Gov gems
gem "govuk_design_system_formbuilder"

group :development do
  gem "foreman"
end

group :test do
  gem "brakeman"
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "govuk_schemas"
  gem "simplecov"
  gem "webmock"
end

group :test, :development do
  gem "listen"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "rubocop-govuk"
end
