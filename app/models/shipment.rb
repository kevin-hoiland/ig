class Shipment < ActiveRecord::Base

  attr_accessible :ship_date, :product_cost, :shipping_cost, :labor_cost, :sales_tax_cost, :donations_cost, :other_costs, :income, :profit, as: :admin
  
#  has_and_belongs_to_many :users
  has_many :gum_shipment_relationships
  
  #took this out because Active Admin was being weird after upgrading gem version lol
#  validates :date, :presence => true

  # 100 million is max $ value, db percision=10 and scale=2, thus ceiling is $99,999,999.99
=begin
  validates :product_cost, :length => { :maximum => 11 }
  validates :shipping_cost, :length => { :maximum => 11 }
  validates :labor_cost, :length => { :maximum => 11 }
  validates :sales_tax_cost, :length => { :maximum => 11 }
  validates :donations_cost, :length => { :maximum => 11 }
  validates :other_costs, :length => { :maximum => 11 }
  validates :income, :length => { :maximum => 11 }
  validates :profit, :length => { :maximum => 11 }
=end
  
  def get_monthly_gums (shipment_id)
    set = GumShipmentRelationship.where(:shipment_id => shipment_id)
      return(set)
  end
  
  def get_monthly_pieces (shipment_id)
    set = GumShipmentRelationship.where(:shipment_id => shipment_id)
    return(set.sum(:pieces))
  end
  
  def month_formatted(date)
     date.strftime '%B %Y'
  end
  
end
