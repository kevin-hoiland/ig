class Shipment < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :date, :product_cost, :shipping_cost, :labor_cost, :sales_tax_cost, :donations_cost, :other_costs, :income, :profit, as: :admin

#  accepts_nested_attributes_for :gums
  
  
  has_and_belongs_to_many :users
  has_many :gum_shipment_relationships
#  has_and_belongs_to_many :gums, :join_table => :gum_shipments
  
  
  def get_monthly_gums (shipment_id)
    set = GumShipmentRelationship.where(:shipment_id => shipment_id)
#    if set.empty?
#      return("none")
#    else
      return(set)
#    end
  end
  
  def get_monthly_pieces (shipment_id)
    set = GumShipmentRelationship.where(:shipment_id => shipment_id)
    return(set.sum(:pieces))
  end
  
  def custom_time_format(time)
    Time::DATE_FORMATS[:w3cdtf] = lambda { |time| time.strftime("%Y-%m-%dT%H:%M:%S# {time.formatted_offset}") }
  end
  
  def month_formatted(date)
     date.strftime '%B %Y'
  end
  
end
