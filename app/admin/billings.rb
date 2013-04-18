ActiveAdmin.register Billing do
  menu :parent => "Member Info"

  before_filter :cancel_with_gateway_and_save_deleted_info, :only => [:destroy]
  
  index do
    column :id
    column :user_id do |row|  
      link_to row.user_id, admin_user_path(row.user_id)
    end
    column "Sub #", :subscription_number
    column "Gateway ID", :gateway_subscriber_id
    column "Sub Name", :subscription_name
    column "Ship Last Name", :ship_last_name
    column "Ship Company", :ship_company
    column "Ship Street", :ship_street
    column "Ship City", :ship_city
    column "Created", :created_at
    column "Updated", :updated_at
    default_actions
  end

  controller do
    def cancel_with_gateway_and_save_deleted_info #almost done :-)
      billing = Billing.find(params[:id])      
      profile = Profile.find_by_user_id(billing.user_id)
      log = DeletedObject.new
      log.deleted_type = "Billing Subscription"
      log.reason = "Billing Subscription Deleted by Intl Gum Admin"
      log.user_id = billing.user_id
      log.profile_id = profile.id
      log.user_email = current_user.email
      log.billing_gateway_subscriber_id = billing.gateway_subscriber_id
      log.billing_subscription_id = billing.id
      log.billing_last_four = billing.last_four
      log.billing_bill_name = billing.bill_first_name+" "+billing.bill_last_name+" (company: "+billing.bill_company+")"
      log.billing_ship_name = billing.ship_first_name+" "+billing.ship_last_name+" (company: "+billing.ship_company+")"
      log.deleted_object_creation_dt = billing.created_at
      log.save
      profile.subscriptions_deleted += 1      
      profile.save
    end
  end
  
end
