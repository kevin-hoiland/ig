class CreateDeletedObjects < ActiveRecord::Migration
  def change
    create_table :deleted_objects do |t|
      t.string "deleted_type"
      t.integer "user_id"
      t.string "user_email"
      t.integer "profile_id"
      t.integer "billing_subscription_id"
      t.integer "billing_last_four"
      t.string "billing_last_name"
      t.string "billing_shipping_name"
      t.integer "billing_gateway_subscriber_id"
      t.string "profile_sex"
      t.string "profile_location"
      t.string "profile_age"
      t.string "votes_count"
      t.string "rating_count"
      t.text "reason"
      t.datetime "deleted_object_creation_dt"
      t.timestamps
    end
  end
end
