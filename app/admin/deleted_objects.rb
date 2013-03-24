ActiveAdmin.register DeletedObject do
    menu :parent => "Application"
    
    index do
      column :id
      column "Type", :deleted_type
      column :user_id do |deleted|  
        link_to deleted.user_id, admin_user_path(deleted.user_id)
      end
      column "Sub #", :subscription_id
      column "Originally Created", :original_creation_dt
      column "Actually Deleted", :created_at
      column "Deleted Info Updated", :updated_at
      default_actions
    end
    
end
