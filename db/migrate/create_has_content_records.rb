class CreateHasContentRecords < ActiveRecord::Migration
  def change
    create_table :has_content_records, :force => true do |t|
      t.belongs_to :owner, :polymorphic => true
      t.string :name
      t.text :content
      t.timestamps
    end
    add_index :has_content_records, [:owner_id, :owner_type, :name], :unique => true
  end
end