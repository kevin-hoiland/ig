ActiveAdmin.register DynamicText do
  menu :parent => "Application"
  scope :news
  scope :faqs
  index do
    column :id
    column "Location", :location
    column "Sequence", :sequence
    column "Font Size", :size
    column "Visible", :visible
    column "Created At", :created_at
    column "Last Updated", :updated_at
    default_actions
  end
  
end
