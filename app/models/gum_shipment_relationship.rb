class GumShipmentRelationship < ActiveRecord::Base

  ############  attributes  ############
  attr_accessible :gum_id, :shipment_id, :pieces, as: :admin
  
  ############  validations  ############
  validates :shipment, :presence => true
  validates :gum, :presence => true
  
  ############  associations  ############
  belongs_to :shipment
  belongs_to :gum
  
  ############  scopes  ############
  
end
