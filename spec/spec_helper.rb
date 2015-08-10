# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
ENV["GOVUK_APP_DOMAIN"] = 'test.gov.uk'
ENV["GOVUK_ASSET_ROOT"] = 'http://static.test.gov.uk'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

require 'webmock/rspec'
WebMock.disable_net_connect!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:each) do
    SearchAdmin.services(:rummager_index, double(:rummager_index, add: nil, delete: nil))
  end

  config.before(:each, type: 'controller') do
    login_as_stub_user
  end
end
