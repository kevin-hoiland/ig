class CreateBillings < ActiveRecord::Migration
  def change
    create_table :billings do |t|
      t.references :user
      t.integer "subscription_number"
      t.string "subscription_name"
      t.string "last_four"
      #t.date "expiry"
      t.string "expiry_month"
      t.string "expiry_year"
      # probably not saving cvc, just using for authentication and token
      t.string "gateway_subscriber_id"
      t.string "bill_first_name"
      t.string "bill_last_name"
      t.string "bill_company"
      t.string "bill_street"
      t.string "bill_city"
      t.string "bill_state_province"
      t.string "bill_postal_code"
      t.string "bill_country", :default => "United States"
      t.string "ship_first_name"
      t.string "ship_last_name"
      t.string "ship_company"      
      t.string "ship_street"
      t.string "ship_city"
      t.string "ship_state_province"
      t.string "ship_postal_code"
      t.string "ship_country"
      t.timestamps
    end
    add_index :billings, ['user_id']
  end
end
