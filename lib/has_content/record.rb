module HasContent
  class Record < ActiveRecord::Base
    attr_accessible :content # :name, and :owner are set by content owners
    
    self.table_name = 'has_content_records'
    
    belongs_to :owner, polymorphic: true
    
    validates :name,  presence: true,
                      inclusion: {in: lambda(&:allowed_names), if: :owner},
                      uniqueness: {scope: %w(owner_id owner_type), if: :owner_persisted?}

    before_create :verify_valid_owner! # this badboy is here because owner is sometimes not present at validation
                                       # because content is a has_one on owner, with autosave true
    
    def to_s
      content
    end

    def allowed_names
      owner.try(:content_names) || []
    end
    
    protected
    
    def owner_persisted?
      owner && !owner.new_record?
    end
    
    # see the before_create hook above
    def verify_valid_owner!
      owner.reload # raises ActiveRecord::RecordNotFound if owner not found
      valid? or raise ActiveRecord::RecordInvalid, self
    end
  end
end