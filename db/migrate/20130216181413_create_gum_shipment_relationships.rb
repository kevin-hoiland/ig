class CreateGumShipmentRelationships < ActiveRecord::Migration
  def change
    create_table :gum_shipment_relationships do |t|
      t.references :gum
      t.references :shipment
      t.integer :pieces
      t.timestamps
    end
    add_index :gum_shipment_relationships, ['gum_id', 'shipment_id']
  end
end
