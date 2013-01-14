class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.date "date"
      t.decimal "product_cost"
      t.decimal "shipping_cost"
      t.decimal "labor_cost"
      t.decimal "sales_tax_cost"
      t.decimal "donations_cost"
      t.decimal "other_costs"
      t.decimal "income"
      t.decimal "profit"
      t.timestamps
    end
    add_index :shipments, ['date']
  end
end
