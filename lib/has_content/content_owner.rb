module HasContent
  module ContentOwner
    extend ActiveSupport::Concern
    
    included do
      delegate :content_names, :content_association_names, :to => 'self.class'
      class_attribute :content_names
      self.content_names ||= []
    end
    
    # return a hash of content attributes with their content only (for loaded content only)
    def content_attributes
      content_names.inject({}) do |attrs, name|
        attrs.merge!(name => send(name)) if send("#{name}_content")
        attrs
      end
    end
    
    # include content_attributes in attributes hash
    def attributes
      super.merge content_attributes
    end
    
    module ClassMethods
      def content_association_names
        content_names.map {|name| "#{name}_content"}
      end
    
    protected
      def add_content name, options = {}
        raise ArgumentError, "name should be suitable for a simple attribute method" unless name =~ /\A[_a-z][_a-z0-9]+\Z/i
        if content_names.include?(name)
          raise ArgumentError, "Content #{name} is already declared in #{self.name}"
        else
          add_content_association name, options
        end
      end
      
      def add_content_association name, options
        content_names << name
        
        has_one "#{name}_content".to_sym, options.reverse_merge(:as => 'owner', :class_name => 'HasContent::Record', :dependent => :destroy, :conditions => {name: name}, :autosave => true)
        
        define_method name do
          send("find_or_build_#{name}_content").content
        end
        
        define_method "#{name}=" do |value|
          (send("find_or_build_#{name}_content").content = value).tap do |*|
            if respond_to?(:updated_at?) && send("find_or_build_#{name}_content").changed?
              updated_at_will_change!
            end
          end
        end
        
        define_method "find_or_build_#{name}_content" do
          send("#{name}_content") || send("build_#{name}_content", name: name)
        end
        private "find_or_build_#{name}_content".to_sym
      end
    end
  end
end