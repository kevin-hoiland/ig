class CreateGumsShipmentsJoin < ActiveRecord::Migration
  def up
    create_table :gums_shipments, :id => false do |t|
      t.integer "gum_id"
      t.integer "shipment_id"
    end
    add_index :gums_shipments, ["gum_id", "shipment_id"]
  end

  def down
    drop_table :gums_shipments
  end
end
