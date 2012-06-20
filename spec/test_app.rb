ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ":memory:")

ActiveRecord::Migration.suppress_messages do 
  ActiveRecord::Schema.define do
    create_table(:content_owners, :force => true) do |t|
      t.string :name
      t.timestamps
    end
  
    require_relative '../db/migrate/create_has_content_records'
    CreateHasContentRecords.new.change
  end
end

class ContentOwner < ActiveRecord::Base
  has_content :body
  has_content :excerpt, :sidebar
end