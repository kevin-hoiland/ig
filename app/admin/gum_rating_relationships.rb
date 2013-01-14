ActiveAdmin.register GumRatingRelationship, :as => "Ratings" do
  menu :label => "Ratings"
  menu :parent => "Product Info"
  
  index do
    column :id
    column "Total", :total
    column "Average", :average
    column "Created", :created_at
    column "Updated", :updated_at
    default_actions
  end
  
#  form do |f|
#    f.inputs "Rating Details" do
#      f.input :comment
#      f.input :stat_1
#      f.input :stat_2
#      f.input :stat_3
#    end
#    f.buttons
#  end
  
end
