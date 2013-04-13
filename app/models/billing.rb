class Billing < ActiveRecord::Base

  ############  attributes  ############
  
  attr_accessible :user_id, :subscription_name, :subscription_count, :last_four, :location, :expiry_month, :expiry_year,
                  :bill_first_name, :bill_last_name, :bill_company, :bill_street, :bill_city, :bill_state_province, :bill_postal_code, 
                  :bill_country, :bill_last_name, :ship_first_name, :ship_company, :ship_last_name, :ship_street, :ship_city,
                  :ship_state_province, :ship_postal_code, :ship_country, :subscription_number, as: :admin
  
  attr_accessor :cvc, :pan, :terms, :reason, :copy

  ############  validations  ############
  
  validates :subscription_name, :length => { :maximum => 255 }
  validates :ship_first_name, :length => { :maximum => 50 }
  validates :bill_first_name, :length => { :maximum => 50 }, :presence => true, :on => :create
  validates :ship_last_name, :length => { :maximum => 50 }
  validates :bill_last_name, :length => { :maximum => 50 }, :presence => true, :on => :create
  validates :ship_company, :length => { :maximum => 50 }
  validates :bill_company, :length => { :maximum => 50 }  ###  MAYBE COMPANY NAME OR FIRST&LAST SHOULD EXIST...
  validates :ship_street, :presence => true, :length => { :maximum => 60 }
  validates :bill_street, :presence => true, :length => { :maximum => 60 }
  validates :ship_city, :presence => true, :length => { :maximum => 40 }
  validates :bill_city, :presence => true, :length => { :maximum => 40 }
  validates :ship_state_province, :presence => true # authorize.net restricts at 2 digit state code (UI uses pulldown for input)
  validates :bill_state_province, :presence => true # authorize.net restricts at 2 digit state code (UI uses pulldown for input)
  validates :ship_postal_code, :presence => true, :length => { :maximum => 20 }
  validates :bill_postal_code, :presence => true, :length => { :maximum => 20 }
  validates :ship_country, :presence => true, :length => { :maximum => 60 }
  validates :bill_country, :presence => true, :length => { :maximum => 60 }
  validates :pan, :length => { :in => 13..19 }, :presence => true, :on => :create
  validates :expiry_month, :presence => true, :on => :create
  validates :expiry_year, :presence => true, :on => :create
  validates :cvc, :length => { :in => 3..4 }, :presence => true, :on => :create
  validates_acceptance_of :terms, :message => "^Please accept the terms and conditions"  

  ############  associations  ############
  
  belongs_to :user
  
end
