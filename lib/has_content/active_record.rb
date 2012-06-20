module HasContent
  # has_content concern: allow spcification of content on models
  #
  # content is a polymorphic association that is laoded on demand, and appears as if it were a normal attribute.  
  # The advantages being that you can add content to models without modifying the database schema, and that you
  # can treat pieces of content as objects in their own right (for example in place editing).
  #
  #   class MyModel
  #     has_content :body, :sidebar
  #   end
  module ActiveRecord
    extend ActiveSupport::Concern
    
    module ClassMethods
      # specify that this class has the following named content
      def has_content *names
        include ContentOwner unless self < ContentOwner
        options = names.extract_options!
        raise ArgumentError, "you must supply at least one content name" if names.size == 0
        names.each {|name| add_content(name.to_s, options)}
      end
    end
  end
end