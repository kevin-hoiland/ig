class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user
      t.date "bill_date"
      t.string "bill_card"
      t.decimal "bill_amount", :precision => 5, :scale => 2
      t.string "ship_first_name"
      t.string "ship_last_name"
      t.string "ship_street"
      t.string "ship_city"
      t.string "ship_state_province"
      t.string "ship_postal_code"
      t.string "ship_country"
      t.timestamps
    end
  end
end
