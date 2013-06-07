class ApplicationController < ActionController::Base
  protect_from_forgery
  
  force_ssl
  
  # used to randomize gums list and members lists
  before_filter :set_seed 
  before_filter :reset_seed
  
  # Override build_footer method in ActiveAdmin::Views::Pages
  require 'active_admin_views_pages_base.rb'
  
  # route to 404 page, used with gum and billing urls :-)
  def not_found
    raise ActionController::RoutingError.new('Permalink Not Found')
  end

  def set_seed
    session[:seed] ||= SecureRandom.random_number.to_s[2..20]#.to_i
    session[:seed_expires_at] ||= 1.hours.from_now
  end

  def reset_seed
    unless (session[:seed_expires_at] - Time.now).to_i > 0
      flash.now[:notice] = "Randomized lists for both Gums and Members"
      session[:seed] = SecureRandom.random_number.to_s[2..20]
    end
    session[:seed_expires_at] = 1.hours.from_now
  end

end
