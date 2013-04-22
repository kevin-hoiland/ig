ActiveAdmin.register Version do
  menu :label => "Product Versions"
  menu :parent => "Application"

  index do
    column :id
    column "Version #", :number
    column "Released At", :released_at
    column "Created At", :created_at
    column "Last Updated", :updated_at
    default_actions
  end
  
  controller do
    force_ssl
  end
  
end
