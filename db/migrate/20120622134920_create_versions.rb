class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.datetime "released_at"
      t.text "notes"
      t.decimal "number", :precision => 4, :scale => 2
      t.timestamps
    end
  end
end
