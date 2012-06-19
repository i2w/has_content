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
require_relative '../lib/has_content'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ":memory:")
ActiveRecord::Migration.suppress_messages do 
  ActiveRecord::Schema.define do
    create_table(:content_owners, :force => true) do |t|
      t.string :name
    end
  
    require_relative '../db/migrate/create_has_content_records'
    CreateHasContentRecords.new.change
  end
end

class ContentOwner < ActiveRecord::Base
end