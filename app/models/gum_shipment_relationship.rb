class GumShipmentRelationship < ActiveRecord::Base

  ############  attributes  ############
  attr_accessible :gum_id, :shipment_id, :pieces, as: :admin

  ############  associations  ############
    
  belongs_to :shipment
  belongs_to :gum
  
  
  validates :shipment, :presence => true
  validates :gum, :presence => true
  
end
