# frozen_string_literal: true
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each, js: true) do
    # TODO: Uncomment this line - since it ensures that tests do not leave behind any data after running
    # and also do not depend on data from previous tests
    # DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    # TODO: Uncomment this line - since it ensures that tests do not leave behind any data after running
    # and also do not depend on data from previous tests
    # DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, type: :feature) do
    # TODO: Uncomment this line - since it ensures that tests do not leave behind any data after running
    # and also do not depend on data from previous tests
    # DatabaseCleaner.strategy = :truncation unless Capybara.current_driver == :rack_test
  end

  config.before(:each, :truncation_mode) do
    # TODO: Uncomment this line - since it ensures that tests do not leave behind any data after running
    # and also do not depend on data from previous tests
    # DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    # TODO: Uncomment this line - since it ensures that tests do not leave behind any data after running
    # and also do not depend on data from previous tests
    # DatabaseCleaner.start
  end

  config.append_after(:each) do
    # TODO: Uncomment this line - since it ensures that tests do not leave behind any data after running
    # and also do not depend on data from previous tests
    # DatabaseCleaner.clean
  end
end
