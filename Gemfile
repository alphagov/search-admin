source 'https://rubygems.org'

gem 'rails', '4.2.7.1'

gem 'unicorn', '~> 4.9.0'
gem 'airbrake', '~> 4.3.8'
gem 'mysql2', '~> 0.4.5'
gem 'sass-rails', '~> 5.0.6'
gem 'uglifier', '~> 3.0.4'
gem 'generic_form_builder', '~> 0.13.0'

# GDS managed gems
gem 'plek', '~> 1.12.0'
gem 'gds-sso', '~> 13.2.0'
gem 'govuk_admin_template', '~> 5.0.1'

if ENV["API_DEV"]
  gem "gds-api-adapters", path: "../gds-api-adapters"
else
  gem 'gds-api-adapters', '~> 39.1.0'
end

group :development do
  # quiet_assets doesn't need pessimistic version lock
  # because our code doesn't depend on it.
  gem 'quiet_assets'
end

group :test do
  gem 'cucumber-rails', '~> 1.4.5', require: false
  gem 'database_cleaner', '~> 1.5.3'
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'webmock', '~> 2.3.2'
end

group :test, :development do
  gem 'rspec-rails', '~> 3.5.2'
  gem 'govuk-lint'
  gem 'pry-byebug'
end
