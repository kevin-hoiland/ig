ActiveAdmin.register GumShipmentRelationship, :as => "Shipped Gums" do
  menu :label => "Shipped Gums"
  menu :parent => "Product Info"
  
#  config.per_page = 50
  
  filter :gum, :collection => proc {(Gum.all).map{|g| [g.permalink, g.id]}}
  filter :shipment, :collection => proc {(Shipment.all).map{|s| [s.date, s.id]}}
  
  index do
    column "Combo ID", :id
    column "Gum ID", :gum_id
    column "Gum Name", :gum do |row|  
      link_to row.gum.permalink, admin_gum_path(row.gum_id)
    end
    column "Ship ID", :shipment_id
    column "Ship Date", :shipment do |row|  
      link_to row.shipment.date, admin_shipment_path(row.shipment_id)
    end
    column "Gum Pieces", :pieces
#    column "Created", :created_at
#    column "Updated", :updated_at
    default_actions
  end
  
  form do |f|
    f.inputs "Edit Shipped Gum" do
      f.input :gum, :as => :select, :collection => Gum.all.map {|g| [g.id.to_s+" : "+g.permalink]}
      f.input :shipment, :as => :select, :collection => Shipment.all.map {|s| [s.id.to_s+" : "+s.date.to_s]}
      f.input :pieces
    end
    f.buttons
  end
  
end
