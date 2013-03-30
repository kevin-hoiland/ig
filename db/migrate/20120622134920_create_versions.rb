class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.datetime "released_at"
      t.text "notes"
      t.string "number"
      t.timestamps
    end
  end
end
