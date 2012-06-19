module HasContent
  class Record < ActiveRecord::Base
    self.table_name = 'has_content_records'
    
    belongs_to :owner, polymorphic: true
    
    validates :owner, presence: true
    validates :name, presence: true, inclusion: {in: lambda(&:allowed_names)}, uniqueness: {scope: %w(owner_id owner_type)}

    before_create :check_existence_of_owner # this badboy is here because owner is sometimes not present at validation
                                            # because content is a has_one on owner, with autosave true

    # Contents are only ever instantiated by has_content assoc, and it's convenient for them to
    # always refer.  If they aren't then the save below will fail silently (which is fine)
    def initialize(*)
      super
      save if new_record? && owner
    end

    def to_s
      content
    end

    def allowed_names
      owner.try(:content_names) || []
    end
    
  protected
    def check_existence_of_owner
      owner.reload # raises ActiveRecord::RecordNotFound if owner not found
    end
  end
end