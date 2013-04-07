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
  
=begin  
  form do |f|
    f.inputs "Edit Billing Info" do
      f.input :subscription_name
      f.input :bill_first_name
      f.input :bill_middle_name
    end
    f.buttons
  end
=end

  controller do
    def cancel_with_gateway_and_save_deleted_info #almost done :-)
      user = User.find(params[:id])
      profile = Profile.find_by_user_id(user.id)
      log = DeletedObject.new
      log.deleted_type = "User/Profile"
      log.reason = "User & Profile Deleted by Intl Gum Admin"
      log.user_id = user.id
      log.user_email = user.email
      log.profile_id = profile.id
      log.profile_sex = profile.sex
      log.profile_location = profile.location
      log.profile_age = profile.age
      log.deleted_object_creation_dt = user.created_at
      log.save

#      @log = Datacenter.find(params[:id])
#      @datacenter.destroy
#      redirect_to edit_admin_retailer_path(@datacenter.infrastructure)
    end
  end
  
end
