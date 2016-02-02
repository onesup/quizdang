require 'simplecov'
SimpleCov.start 'rails' unless ENV['NO_COVERAGE']

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Uncomment if you want awesome colorful output
# require 'minitest/pride'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

require 'mocha/mini_test'
require 'faker'

# Clear database
DatabaseCleaner[:active_record].strategy = :transaction

class ActiveSupport::TestCase
  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end
end
