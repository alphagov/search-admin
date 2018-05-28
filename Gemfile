source 'https://rubygems.org'

gem 'rails', '5.2.0'

gem 'mysql2', '~> 0.4.5'
gem 'sass-rails', '~> 5.0.6'
gem 'uglifier', '~> 4.1.10'
gem 'generic_form_builder', '~> 0.13.0'

# GDS managed gems
gem 'plek', '~> 2.1.1'
gem 'gds-sso', '~> 13.6.0'
gem 'govuk_admin_template'
gem "govuk_app_config", "~> 1.5.0"

gem 'gds-api-adapters', '~> 52.5.1'

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot_rails', '~> 4.10.0'
  gem 'govuk-content-schema-test-helpers', '~> 1.6.1'
  gem 'webmock', '~> 3.4.1'
end

group :test, :development do
  gem 'rspec-rails', '~> 3.7.2'
  gem 'rails-controller-testing' # support `expect(..).to render_template(..)` for rails >= 5.0
  gem 'govuk-lint'
  gem 'pry-byebug'
end
