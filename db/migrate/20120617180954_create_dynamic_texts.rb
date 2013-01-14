class CreateDynamicTexts < ActiveRecord::Migration
  def change
    create_table :dynamic_texts do |t|
      t.string "location"
      t.integer "sequence"
      t.text "content"
      t.integer "size"
      t.boolean "visible", :default => '1'
      t.timestamps
    end
  end
end
