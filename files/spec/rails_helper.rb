# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'webmock/rspec'
ENV['RAILS_ENV'] = 'test'
ENV['RSWAG_ENV'] ||= 'development'

# Allow requests to chrome:.* to run system specs
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: [/chrome:.*/]
)

require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

# Parallel tests database verification
# Fail fast if parallel test database is not properly set up
if ENV['TEST_ENV_NUMBER']
  begin
    # Quick connection test to verify database exists and is accessible
    ActiveRecord::Base.connection.execute('SELECT 1')
  rescue StandardError => e
    # Database doesn't exist - should have been created by parallel:prepare
    warn <<~MSG
      ❌ Test database for parallel process #{ENV['TEST_ENV_NUMBER']} is not available.

      Please run the following command to set up parallel test databases:
      docker compose exec web bundle exec rails parallel:prepare

      Error details: #{e.message}
    MSG
    abort
  end
end

# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rails'
require 'active_support/testing/time_helpers'
require 'warden/test/helpers'
require 'view_component/test_helpers'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Rails.root.glob('spec/support/**/*.rb').each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  Rails.logger.debug e.to_s.strip
  abort e.to_s.strip
end
RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include AuthHelper, type: :request
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Warden::Test::Helpers
  config.include ViewComponent::TestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component

  config.define_derived_metadata(file_path: %r{spec/requests/}) do |meta|
    meta[:aggregate_failures] = true
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
