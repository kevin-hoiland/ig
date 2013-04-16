class ProfilesController < ApplicationController

  before_filter :authenticate_user!, :only => [:edit, :update] #, :delete_confirmation, :destroy]
  
  def index
    list
    render('list')
  end

  def list
    @search_profiles = Profile.ransack(params[:q]) # was Profile.search(params[q:])
    @profiles_list = @search_profiles.result(:distinct => true).order("updated_at DESC").page(params[:page]) #.per(5)
  end
  
  def show
    @profile = Profile.find(params[:id])
    @rating_averages = @profile.get_rating_averages
    @rating_count = GumRatingRelationship.with_active_gum.where(:profile_id => @profile.id).count
    #@login_info = User.find(@profile.user_id)
    #@user_votes_up_total = @login_info.vote_count(:up)
    #@user_votes_down_total = @login_info.vote_count(:down)
    
#    @votes_down_total = @login_info.votes_against
#  http://www.williamayd.com/blogs/5
    # @ratings = GumRatingRelationship.find_all_by_user_id(params[:id])
  end
    
  def edit
    @self_profile = Profile.find_by_user_id(current_user.id)
    # @login_info = User.find(@self_profile.user_id)
    # @self_billing = Userbilling.find_by_user_id(@user.id)
    #render('edit')
  end
   
  def update
    @self_profile = Profile.find_by_user_id(current_user.id)
    # @self_profile.name = params[:profile][:name]
    if @self_profile.update_attributes(params[:profile])
      flash[:notice] = "Profile udpated! Go chew some gum :-)"
      redirect_to(profile_url, :id => @self_profile.id)
    else
      flash[:alert] = "Hmm, couldn't udpate your profile"
      render('edit')
    end
  end

=begin
private
  def update_logs
    profile = self.id
    user = User.find_by_id(profile.user_id)
    log = DeletedObject.new
    log.deleted_type = "Profile"
    log.reason = "User/Profile Deleted by Intl Gum Admin"
    log.user_id = user.id
    log.user_email = user.email
    log.profile_id = profile.id
    log.profile_sex = profile.sex
    log.profile_location = profile.location
    log.profile_age = profile.age
    log.original_creation_dt = profile.created_at
    log.save
    #@_current_user = session[:current_user_id] = nil
    #   redirect_to root_url
  end
=end

end



=begin MIGHT DEPRICATE DELETE FEATURE... 

def delete_confirmation
  @profile = Profile.find_by_user_id(current_user.id)
  @content = DynamicText.content("billing_profile")
end
 
  def destroy
    profile = Profile.find_by_user_id(current_user.id)
    if profile.destroy
      flash[:notice] = "Your Intl Gum Membership Account was deleted successfully"
      log = DeletedObject.new
      log.reason = params[:profile][:reason]
      log.profile = profile.id
      log.when_created = profile.created_at
      log.save
      #  NEED TO FORCE LOGOUT!!!!!!!
      redirect_to(root_url)
      #redirect_to(profiles_url)
    else
      flash[:alert] = "Sorry, we were unable to delete your Membership Account"
      redirect_to(profile_url)
    end
=end

=begin OLD LIST WITH COMMENT OUT TRIAL/ERROR ETC  
  def list
    #@search_profiles = Profile.search(params[:search])
    #@profiles_list = @search_profiles.order("updated_at DESC").page(params[:page]).per(5)
    
    # this one was used last, before adding paging...
    @search_profiles = Profile.ransack(params[:q]) # was Profile.search(params[q:])
    @profiles_list = @search_profiles.result.order("updated_at DESC").page(params[:page]) #.per(5)
    
    #@profiles_list = Profile.search(params[:q]).result(:distinct => true).order("updated_at DESC").page(params[:page]).per(10)
    
    
    #@profiles_list = Profile.order("updated_at DESC").page(params[:page]).per(1)
    #@profiles_list = Profile.all
    # @profiles_list = Profile.search_name(params[:name]).search_location(params[:location]))\
  end
=end

=begin  MOVED TO BILLING CONTROLLER
  def edit_private
    @self_billing = Billing.find_by_user_id(current_user.id)
    @login_info = User.find(@self_billing.user_id)
    @content_top = DynamicText.content("billing_top")
    @content_bottom = DynamicText.content("billing_bottom")
    # @self_billing = Userbilling.find_by_user_id(@user.id)
    #render('edit')
  end
=end


=begin  MOVED TO BILLING CONTROLLER
def update_billing
  @self_billing = Billing.find_by_user_id(current_user.id)
        # @self_billing = Userbilling.find(params[:id])
        @self_billing.ship_name = params[:billing][:ship_name]
        @self_billing.ship_street = params[:billing][:ship_street]
        @self_billing.ship_city = params[:billing][:ship_city]
        @self_billing.ship_state_province = params[:billing][:ship_state_province]
        @self_billing.ship_postal_code = params[:billing][:ship_postal_code]
        @self_billing.ship_country = params[:billing][:ship_country]
        @self_billing.bill_street = params[:billing][:bill_street]
        @self_billing.bill_city = params[:billing][:bill_city]
        @self_billing.bill_state_province = params[:billing][:bill_state_province]
        @self_billing.bill_postal_code = params[:billing][:bill_postal_code]
        @self_billing.bill_country = params[:billing][:bill_country]
        @self_billing.bill_first_name = params[:billing][:bill_first_name]
        @self_billing.bill_middle_name = params[:billing][:bill_middle_name]
        @self_billing.bill_last_name = params[:billing][:bill_last_name]
       # @self_billing.expiry = params[:billing][:expiry]
        @self_billing.expiry_month = params[:billing][:expiry_month]
        @self_billing.expiry_year = params[:billing][:expiry_year]
        @self_billing.cvc = params[:billing][:cvc]
        @self_billing.pan = params[:billing][:pan].gsub(/[^0-9]/, "")
        @self_billing.terms = params[:billing][:terms]
        #@self_billing.pan = gsub("[^0-9]", "")
        if @self_billing.pan > ""  # Only update the last_four DB value from pan attribute accessor if something exists for pan
          @self_billing.last_four = @self_billing.pan.to_s.slice(-4..-1)
        end
        #  LOGIC FOR CREATING pan_token AND SAVING .... don't actually save PAN/CVC (attribute accessor)
  #     if @self_billing.update_attributes(params[:billing])
        if @self_billing.save
          #if params[:billing][:terms] == true
            # DUDE, BILLING BELONGS TO PROFILE, SO COULD GET IT THAT WAY TOO...
            profile = Profile.find_by_user_id(current_user.id)
            profile.subscriber = 1
            if profile.save
              flash[:notice] = "Congratulations, you are now a Subscriber!"
            end
          #else
            #else
             # flash[:notice] = "Private Info Updated, but still not yet Subscribed"
            #end
          #end
          #redirect_to(profile_url, :id => @self_billing.user_id)
          redirect_to(profile_url(@self_billing.user_id))
          
        else
          flash[:alert] = "Unable to Update Private Info"
          #@self_billing = Billing.find_by_user_id(current_user.id)
          #@login_info = User.find(@self_billing.user_id)
          @content_top = DynamicText.content("billing_top")
          @content_bottom = DynamicText.content("billing_bottom")
          render('edit_private')
        end    
end
=end