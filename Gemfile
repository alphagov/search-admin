source "https://rubygems.org"

gem 'rails', '6.0.1'

gem 'generic_form_builder', '~> 0.13.1'
gem 'mysql2', '~> 0.4.5'
gem 'sass-rails', '~> 6.0'
gem 'uglifier', '~> 4.2.0'
gem 'bootsnap', '~> 1.1', '>= 1.1.7'

# GDS managed gems
gem 'gds-sso', '~> 14.2.0'
gem 'govuk_admin_template'
gem 'govuk_app_config', '~> 2.0.1'
gem 'plek', '~> 3.0.0'

gem 'gds-api-adapters', '~> 63.0.0'

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot_rails', '~> 5'
  gem 'govuk-content-schema-test-helpers', '~> 1.6.1'
  gem 'webmock', '~> 3.7.6'
end

group :test, :development do
  gem 'govuk-lint'
  gem 'pry-byebug'
  gem 'rails-controller-testing' # support `expect(..).to render_template(..)` for rails >= 5.0
  gem 'rspec-rails', '~> 4.0.0.beta3'
  gem 'listen', '~> 3.2'
end
