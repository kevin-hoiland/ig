ActiveAdmin.register Profile do
  actions :index, :show, :new, :create, :update, :edit #everything but :delete
  menu :label => "Profiles"
  menu :parent => "Member Info"
  scope :active_subscriber
  scope :not_subscribed
  index do
    column "Profile ID", :id
    column :user_id do |row|  
      link_to row.user_id, admin_user_path(row.user_id)
    end
    #column "User ID", :user_id
    column "Name", :name
    column "Created", :created_at
    column "Subs Created", :subscriptions_created
    column "Subs Cancelled", :subscriptions_deleted
    default_actions
  end
  
end
