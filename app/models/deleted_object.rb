class DeletedObject < ActiveRecord::Base

  ############  attributes  ############
  attr_accessible :deleted_type, :user_id, :user_email, :profile_id, :billing_subscription_id, :billing_last_four, 
                  :billing_bill_name, :billing_ship_name, :billing_gateway_subscriber_id, :profile_sex, 
                  :profile_location, :profile_age, :votes_count, :rating_count, :reason, :deleted_object_creation_dt, as: :admin
  
  ############  validations  ############
  validates :reason, :length => { :maximum => 5000 }
  
  ############  associations  ############
  
  ############  scopes  ############

end
