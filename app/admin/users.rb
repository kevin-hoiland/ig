ActiveAdmin.register User do
  
  actions :index, :show, :destroy, :delete
  
  before_filter :set_deleted_object_data, :only => [:destroy]
  
  menu :label => "Users"
  menu :parent => "Member Info"
  
  index do
    column :id
    column "Email/Login", :email
    column "Last IP Address", :last_sign_in_ip
    column "Created", :created_at
    column "Last Signed In", :last_sign_in_at
    column "# Sign Ins", :sign_in_count
    default_actions
  end
  
  form do |f|
    f.inputs "Edit User" do
      f.input :email
    end
    f.buttons
  end

=begin 
  show do
          panel "User Details" do
                  attributes_table_for user, 
                          :id,
                          :email,
                          :reset_password_sent_at,
                          :remember_created_at,
                          :sign_in_count,
                          :current_sign_in_at,
                          :last_sign_in_at,
                          :current_sign_in_ip,
                          :last_sign_in_ip,
                          :created_at,
                          :updated_at
          end
  end
=end
  
  controller do
    def set_deleted_object_data
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
    end
  end
    
  
end
