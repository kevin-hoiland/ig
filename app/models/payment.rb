class Payment < ActiveRecord::Base
  
  ############  attributes  ############
  attr_accessible :user_id, :bill_date, :bill_card, :bill_amount, :ship_first_name, :ship_last_name, :ship_street, :ship_city, :ship_state_province, :ship_postal_code, :ship_country, as: :admin

  ############  associations  ############
  belongs_to :user
   
end
