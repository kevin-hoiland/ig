ActiveAdmin.register Vote do
    menu :parent => "Product Info"
    
    index do
      column :id
      column :vote
      column :voteable
#      column :voteable_type
#      column :voter_type
      column :voter
      column :created_at
      column :updated_at
#      default_actions
    end
    
end