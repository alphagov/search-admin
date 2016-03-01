source 'https://rubygems.org'

gem 'rails', '4.2.5.2'

gem 'unicorn', '~> 4.9.0'
gem 'airbrake', '~> 3.1.16'
gem 'plek', '~> 1.10.0'

gem 'mysql2', '~> 0.3.19'
gem 'gds-sso', '~> 9.3.0'
gem 'rummageable', '~> 1.2.0'
gem 'gds-api-adapters', '~> 23.1.0'

gem 'govuk_admin_template', '~> 4.1.1'

gem 'sass-rails', '~> 5.0.3'
gem 'uglifier', '~> 2.7.2'

gem 'generic_form_builder', '~> 0.8.0'

group :development do
  # quiet_assets and byebug don't need pessimistic version lock
  # because our code doesn't depend on them.
  gem 'quiet_assets'
  gem 'byebug'
end

group :test do
  gem 'rspec-rails', '~> 3.3.3'
  gem 'cucumber-rails', '~> 1.4.2', require: false
  gem 'database_cleaner', '~> 1.4.1'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'webmock', '~> 1.21.0'
end

group :test, :development do
  gem 'govuk-lint', '~> 0.8.1'
end
