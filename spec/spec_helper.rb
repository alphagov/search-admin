# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"
ENV["GOVUK_ASSET_ROOT"] = "http://static.test.gov.uk"

require "simplecov"
SimpleCov.start "rails" do
  enable_coverage :branch
end

require File.expand_path("../config/environment", __dir__)
require "rspec/rails"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

require "webmock/rspec"
WebMock.disable_net_connect!

require "grpc_mock/rspec"
GrpcMock.disable_net_connect!

require "govuk_sidekiq/testing"
Sidekiq::Testing.fake!
# Avoid unhelpful connection logs in RSpec output (https://github.com/sidekiq/sidekiq/issues/6181)
Sidekiq.default_configuration.logger.level = Logger::WARN

# Required to be able to mock Google classes in tests (as classes from the `v1` namespace are not
# used directly in non-test code, they are not loaded by the gem's lazy loading)
require "google/cloud/discovery_engine/v1"

Rails.application.load_tasks

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.disable_monkey_patching!

  config.fixture_paths = [Rails.root.join("spec/fixtures")]
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.include FactoryBot::Syntax::Methods

  config.include_context "with an SSO authenticated user", type: :system

  config.before(:each) do
    Sidekiq::Worker.clear_all
  end

  config.before(:each, type: :system) do
    driven_by :rack_test
  end
end
