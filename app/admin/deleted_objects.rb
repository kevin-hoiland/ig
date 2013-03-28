ActiveAdmin.register DeletedObject do
  actions :index, :show, :new, :create, :update, :edit #everything but :delete
  menu :parent => "Application"
  
  index do
    column :id
    column "Type", :deleted_type
#    column :user_id do |deleted|  
#      link_to deleted.user_id, admin_user_path(deleted.user_id)
#    end
    column "User ID", :user_id
    column "Sub #", :billing_subscription_id
    column "Gateway ID", :billing_gateway_subscriber_id
    column "Ratings", :rating_count
    column "Object Created", :deleted_object_creation_dt
    column "Object Deleted", :created_at
    default_actions
  end
    
end
