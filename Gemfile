source 'https://rubygems.org'

gem 'rails', '5.1.4'

gem 'unicorn', '~> 5.4.0'
gem 'mysql2', '~> 0.4.5'
gem 'sass-rails', '~> 5.0.6'
gem 'uglifier', '~> 4.1.4'
gem 'generic_form_builder', '~> 0.13.0'

# GDS managed gems
gem 'plek', '~> 2.1.0'
gem 'gds-sso', '~> 13.5.1'
gem 'govuk_admin_template'
gem "govuk_app_config", "~> 1.2.1"

gem 'gds-api-adapters', '~> 51.2.0'

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner', '~> 1.6.2'
  gem 'factory_bot_rails', '~> 4.8.2'
  gem 'govuk-content-schema-test-helpers', '~> 1.6.0'
  gem 'webmock', '~> 3.3.0'
end

group :test, :development do
  gem 'rspec-rails', '~> 3.7.2'
  gem 'rails-controller-testing' # support `expect(..).to render_template(..)` for rails >= 5.0
  gem 'govuk-lint'
  gem 'pry-byebug'
end
