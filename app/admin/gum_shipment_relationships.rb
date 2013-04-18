ActiveAdmin.register GumShipmentRelationship, :as => "Shipped Gums" do
  menu :label => "Shipped Gums"
  menu :parent => "Product Info"
  
#  config.per_page = 50
  
  filter :gum, :collection => proc {(Gum.all).map{|g| [g.permalink, g.id]}}
  filter :shipment, :collection => proc {(Shipment.all).map{|s| [s.ship_date, s.id]}}
  
  index do
    column "Combo ID", :id
    column "Gum ID", :gum_id
    column "Gum Name", :gum do |row|  
      link_to row.gum.permalink, admin_gum_path(row.gum_id)
    end
    column "Ship ID", :shipment_id
    column "Ship Date", :shipment do |row|  
      link_to row.shipment.ship_date, admin_shipment_path(row.shipment_id)
    end
    column "Gum Pieces", :pieces
    default_actions
  end
  
  form do |f|
    f.inputs "Edit Shipped Gum" do
      if f.object.new_record?
        f.input :gum, :as => :select, :collection => Gum.all.map {|g| [g.id.to_s+" : "+g.permalink]}
        f.input :shipment, :as => :select, :collection => Shipment.all.map {|s| [s.id.to_s+" : "+s.ship_date.to_s]}
      else
        f.input :gum, :as => :select, :collection => Gum.all.map {|g| [g.id.to_s+" : "+g.permalink]}, :selected => f.object.gum.id.to_s+" : "+f.object.gum.permalink
        f.input :shipment, :as => :select, :collection => Shipment.all.map {|s| [s.id.to_s+" : "+s.ship_date.to_s]}, :selected => f.object.shipment.id.to_s+" : "+f.object.shipment.ship_date.to_s
      end     
      f.input :pieces
    end
    f.buttons
  end
  
  show do
    attributes_table do
      row :id
      row :gum
      row :shipment do |row|  
        link_to row.shipment.ship_date, admin_shipment_path(row.shipment_id)
      end
      row :pieces
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
  
end
