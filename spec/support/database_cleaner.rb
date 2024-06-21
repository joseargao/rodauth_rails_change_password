# frozen_string_literal: true

# spec/support/database_cleaner.rb
# spec/rails_helper.rb
require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  # For preserving data between test examples in the same file
  config.before(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
