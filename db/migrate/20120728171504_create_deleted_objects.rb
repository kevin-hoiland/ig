class CreateDeletedObjects < ActiveRecord::Migration
  def change
    create_table :deleted_objects do |t|
      t.string "deleted_type"
      t.integer "user_id"
      t.string "email"
      t.integer "profile_id"
      t.integer "subscription_id"
      t.integer "last_four"
      t.string "bill_last_name"
      t.string "ship_name"
      t.text "reason"
      t.datetime "original_creation_dt"
      t.timestamps
    end
  end
end
