ActiveAdmin.register GumRatingRelationship, :as => "Ratings" do
  menu :label => "Ratings"
  menu :parent => "Product Info"
  
  index do
    column :id
    column :gum_id
    column "Total", :total
    column "Average", :average
    column "Created", :created_at
    column "Updated", :updated_at
    default_actions
  end
    
end
