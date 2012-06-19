module HasContent
  class Record < ActiveRecord::Base
    self.table_name = 'has_content_records'
    
    belongs_to :owner, :polymorphic => true
    
    validates :owner, :presence => true
    validates :name, :presence => true, :format => /^[_a-z][_a-z0-9]*$/i, :uniqueness => {:scope => [:owner_id, :owner_type]}
  end
end