class GumShipmentRelationship < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :gum_id, :shipment_id, :pieces, as: :admin
  belongs_to :shipment
  belongs_to :gum
  
end
