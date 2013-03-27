ActiveAdmin.register User do
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
  
  
end
