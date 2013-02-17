class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.date "date"
      t.decimal "product_cost", :precision => 10, :scale => 2
      t.decimal "shipping_cost", :precision => 10, :scale => 2
      t.decimal "labor_cost", :precision => 10, :scale => 2
      t.decimal "sales_tax_cost", :precision => 10, :scale => 2
      t.decimal "donations_cost", :precision => 10, :scale => 2
      t.decimal "other_costs", :precision => 10, :scale => 2
      t.decimal "income", :precision => 10, :scale => 2
      t.decimal "profit", :precision => 10, :scale => 2
      t.timestamps
    end
    add_index :shipments, ['date']
  end
end
