require 'rubygems'
require 'spork'
require 'capybara/rspec'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    # config.mock_with :rspec

    # We apparently cannot add a before filter here, since request and
    # controller aren't available. Yet they are if the filter is added to the
    # example block. Odd!
    config.include SubdomainSpec, type: :controller
    config.include WaitForXHR,    type: :request

    # Handle `it('thing', :js)` as `it('thing', js: true)`.
    config.treat_symbols_as_metadata_keys_with_true_values = true

    # Languages
    # ---------

    # Default all test runs to use English; you can change this in each
    # individual test, or in a before(:each) block.
    #
    config.before(:each) { I18n.locale = 'en' }

    # Database
    # --------

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false
    config.include FactoryGirl::Syntax::Methods

    # Integration tests should use truncation; real requests aren't wrapped
    # in a transaction, so neither should high-level tests. These filters need
    # to be above the filter which starts DatabaseCleaner.

    config.before(:each, type: :request) do
      DatabaseCleaner.strategy = :truncation
    end

    config.after(:each, type: :request) do
      DatabaseCleaner.strategy = :transaction
    end

    # The database_cleaner gem is used to restore the DB to a clean state before
    # each example runs. This is used in preference over rspec-rails'
    # transactions since we also need this behaviour in Cucumber features.

    config.before(:suite) { DatabaseCleaner.strategy = :transaction }
    config.before(:each)  { DatabaseCleaner.start                   }
    config.after(:each)   { DatabaseCleaner.clean                   }

    # Capybara
    # --------

    Capybara.javascript_driver = :webkit
    Capybara.server_port = '54163'
    Capybara.app_host    = 'http://gasmixer.mixer.dev:54163'

  end
end

Spork.each_run do
  FactoryGirl.reload
end
