ActiveAdmin.register AdminUser do
  actions :index, :show, :update, :edit #everything but :delete :create :new
  
  menu :label => "Admin Users"
  menu :parent => "Application"

  index do
    column :id
    column "Email/Login", :email
    column "IP Addresss", :last_sign_in_ip
    column "Last Updated", :updated_at
    default_actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
    end
    f.buttons
  end
  
  show do
    attributes_table do
      row :id
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
  
  controller do
    force_ssl
  end
  
end
