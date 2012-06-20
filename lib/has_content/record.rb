module HasContent
  class Record < ActiveRecord::Base
    self.table_name = 'has_content_records'
    
    belongs_to :owner, polymorphic: true
    
    validates :name,  presence: true,
                      inclusion: {in: lambda(&:allowed_names), if: :owner},
                      uniqueness: {scope: %w(owner_id owner_type), if: :owner_persisted?}

    before_create :verify_valid_owner! # this badboy is here because owner is sometimes not present at validation
                                       # because content is a has_one on owner, with autosave true

    # Contents are only ever instantiated by has_content assoc, and it's convenient for them to
    # always refer (for links to content etc).
    # If there is a validation problem, the save will fail silently (which is fine)
    def initialize(*)
      super
      save if new_record? && owner_persisted?
    end

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