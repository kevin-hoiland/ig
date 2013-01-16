class CreateGums < ActiveRecord::Migration
  def change
    create_table :gums do |t|
      t.string "permalink", :null => false
      t.string "upc", :null => false
      t.boolean "active", :default => true, :null => false
      t.string "company", :default => ""
      t.string "brand", :default => ""
      t.string "flavor", :default => ""
      t.string "description", :default => ""
      t.string "note", :default => ""
      t.string "country", :default => ""
      t.boolean "new_release", :default => false, :null => false
      t.boolean "discontinued", :default => false, :null => false
      t.string "image"
      t.timestamps
    end
    add_index :gums, ['permalink']
  end
end
