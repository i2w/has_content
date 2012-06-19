require 'has_content/version'
require 'has_content/record'
require 'has_content/content_owner'
require 'has_content/active_record'
require 'has_content/engine' if defined?(Rails)

ActiveSupport.on_load(:active_record) do
  include HasContent::ActiveRecord
end