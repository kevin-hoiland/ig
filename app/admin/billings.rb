ActiveAdmin.register Billing do
  menu :parent => "Member Info"
  
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

end
