require 'spec_helper'

ActiveRecord::Migration.suppress_messages do
  ActiveRecord::Schema.define(:version => 0) do
    create_table(:content_owners, :force => true) do
      |t| t.string :name
    end
    
    ActiveRecord::Migrator.up "db/migrate"
  end
end

class ContentOwner < ActiveRecord::Base
  #has_content :body
end

describe ContentOwner do
  it 'should be foo' do
    binding.pry
  end
end