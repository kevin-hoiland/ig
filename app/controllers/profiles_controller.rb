class ProfilesController < ApplicationController

  before_filter :authenticate_user!, :only => [:edit, :update]
  
  def index
    list
    render('list')
  end

  def list
    @search_profiles = Profile.ransack(params[:q])
    @profiles_list = @search_profiles.result(:distinct => true).order("updated_at DESC").page(params[:page])
  end
  
  def show
    @profile = Profile.find(params[:id])
    @rating_averages = @profile.get_rating_averages
    @rating_count = GumRatingRelationship.with_active_gum.where(:profile_id => @profile.id).count
  end
    
  def edit
    @self_profile = Profile.find_by_user_id(current_user.id)
  end
   
  def update
    @self_profile = Profile.find_by_user_id(current_user.id)
    if @self_profile.update_attributes(params[:profile])
      flash[:notice] = "Profile udpated! Go chew some gum :-)"
      redirect_to(profile_url, :id => @self_profile.id)
    else
      flash[:alert] = "Hmm, sorry, couldn't udpate your profile"
      render('edit')
    end
  end

end
