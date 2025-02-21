source "https://rubygems.org"

gem "rails", "8.0.1"

gem "bootsnap", require: false
gem "csv"
gem "dartsass-rails"
gem "google-cloud-discovery_engine"
gem "google-cloud-discovery_engine-v1beta"
gem "mysql2"
gem "sentry-sidekiq"
gem "sprockets-rails"

# GDS managed gems
gem "gds-api-adapters"
gem "gds-sso"
gem "govuk_app_config"
gem "govuk_publishing_components"
gem "govuk_sidekiq"
gem "mail-notify"
gem "plek"

group :development do
  gem "foreman"
end

group :test do
  gem "factory_bot_rails"
  gem "govuk_schemas"
  gem "govuk_test"
  gem "grpc_mock"
  gem "simplecov"
  gem "webmock"
end

group :test, :development do
  gem "listen"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "rubocop-govuk"
end
