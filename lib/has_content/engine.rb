module HasContent
  class Engine < Rails::Engine
  end
end

ActiveSupport.on_load(:active_record) do
  include HasContent::Record
end