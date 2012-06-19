ENV['RAILS_ENV'] = 'test'

if ENV['SIMPLECOV']
  require 'simplecov'
  SimpleCov.start do
    add_filter "_spec.rb"
  end
end

begin
  require 'pry'
rescue LoadError
end

require 'active_record'
require 'rspec'
require 'database_cleaner'

require_relative '../lib/has_content'
require_relative 'test_app'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean_with :truncation

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:each) { DatabaseCleaner.start }
  config.after(:each)  { DatabaseCleaner.clean }
end