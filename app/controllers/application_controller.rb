class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Override build_footer method in ActiveAdmin::Views::Pages
    require 'active_admin_views_pages_base.rb'
    
    # route to 404 page, used with gum urls :-)
    def not_found
      raise ActionController::RoutingError.new('Gum Permalink Not Found')
    end
    
end
