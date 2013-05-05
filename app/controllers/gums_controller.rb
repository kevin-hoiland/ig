class GumsController < ApplicationController

  before_filter :authenticate_user!, :only => [:vote_up, :vote_up2, :vote_down2, :vote_down]

  def index
    list
    render('list')
  end
  
  def list
    @content_legal = DynamicText.content("gum_general").order("sequence ASC")
    @search_gums = Gum.active.ransack(params[:q])
#   @search_gums = Gum.omg("desc").active.ransack(params[:q])
    @gums_list = @search_gums.result(:distinct => true).order('RAND('+session[:seed]+')').page(params[:page])
    @country_list = Gum.active.select(:country).uniq
  end
  
  def show
    @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
    @gum = Gum.active.find_by_permalink(params[:id]) || not_found
    @votes_up_total = @gum.votes_for
    @votes_down_total = @gum.votes_against
    @rating_averages = @gum.get_rating_averages
    @rating_count = GumRatingRelationship.where(:gum_id => @gum.id).count
  end
  
  def vote_up
    gum = Gum.active.find_by_permalink(params[:permalink]) || not_found
    if current_user.voted_against?(gum)
      current_user.vote_exclusively_for(gum)
      flash[:notice] = "Changed your vote from Bust to Bubble"
      redirect_to(new_rating_url(gum.permalink))
    else
      flash[:notice] = "New Bubble Vote Counted!"
      current_user.vote_exclusively_for(gum)
      redirect_to(new_rating_url(gum.permalink))
    end
  end
  
  def vote_down
    gum = Gum.active.find_by_permalink(params[:permalink]) || not_found
    if current_user.voted_for?(gum)
      current_user.vote_exclusively_against(gum)
      flash[:notice] = "Changed your vote from Bubble to Bust"
      redirect_to(new_rating_url(gum.permalink))
    else
      flash[:notice] = "New Bust Vote Counted!"
      current_user.vote_exclusively_against(gum)
      redirect_to(new_rating_url(gum.permalink))
    end
  end
  
end
