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

  config.include FactoryBot::Syntax::Methods

  config.before(:each) do
    # search URLs are of the form: http://search.dev.gov.uk/mainstream/document/http://test.dev.gov.uk
    # The part after /document/ is optional depending on the request type
    search_url_regex = %r{#{Plek.find('search')}/.+/.+(/.*)?}
    stub_request(:post, search_url_regex)
    stub_request(:delete, search_url_regex)
  end

  config.before(:each, type: 'controller') do
    login_as_stub_user
  end

  require 'govuk-content-schema-test-helpers'

  GovukContentSchemaTestHelpers.configure do |schema_config|
    schema_config.schema_type = 'publisher_v2'
    schema_config.project_root = Rails.root
  end
end
