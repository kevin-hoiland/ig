class RatingsController < ApplicationController

  before_filter :authenticate_user!, :only => [:edit, :new, :create, :update]
  
  def index
    list
    render('list')
  end
  
  def list
    @search_ratings = GumRatingRelationship.ransack(params[:q])
    @ratings_list = @search_ratings.result(:distinct => true).order("updated_at DESC").page(params[:page])
    # @ratings_list = GumRatingRelationship.order("updated_at DESC").page(params[:page]).per(5)
  end
  
  def show
    @rating = GumRatingRelationship.find(params[:id])
  end
  
  def per_gum
    #@gum = Gum.find(params[:gum_id])
    @gum = Gum.find_by_permalink(params[:gum_permalink]) || not_found 
    @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
    @search_ratings = GumRatingRelationship.ransack(params[:q])
    @ratings = @search_ratings.result(:distinct => true).where(:gum_id => @gum.id).order("updated_at DESC").page(params[:page])    
    # @ratings = Kaminari.paginate_array(GumRatingRelationship.find_all_by_gum_id(@gum.id, :order => 'created_at DESC')).page(params[:page])
  end
  
  def per_member
    @profile = Profile.find(params[:id])
    @content_legal = DynamicText.content("gum_general").order("sequence ASC")
    @search_ratings = GumRatingRelationship.ransack(params[:q])
    @ratings = @search_ratings.result(:distinct => true).where(:profile_id => @profile.id).order("updated_at DESC").page(params[:page])
    # @ratings = Kaminari.paginate_array(GumRatingRelationship.find_all_by_profile_id(@profile.id, :order => 'created_at DESC')).page(params[:page])

  end
  
  def edit
    @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
    @changed_rating = GumRatingRelationship.find(params[:id])
    @gum = Gum.find(@changed_rating.gum_id)
    
    # trying to fix feb 22nd 2013
    # unless current_user.id == @changed_rating.profile_id  ########################### THIS IS NOT GUARENTEED, WTF, SHOULD BE USER_ID EVERYWHERE...
    unless User.find(current_user.id).profile.id == @changed_rating.profile_id
      flash[:alert] = "Come on dude, you can't edit someone else's rating, seriously, this isn't amateur hour..."
      redirect_to(ratings_url)
    end
    #@gum = Gum.find(params[:gum_id])
    #@gum = Gum.find_by_id(@rating.gum_id)
    #@gum = Gum.find(3)
  end
  
  def new
    @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
    #@gum = Gum.find(params[:gum_id])
    @gum = Gum.find_by_permalink(params[:gum_permalink]) || not_found
    @profile = Profile.find_by_user_id(current_user.id)
    @help = GumRatingRelationship.already_rated(@profile.id, @gum.id).exists? ### probably don't need this long term, maybe was just for debuggin?
    if GumRatingRelationship.already_rated(@profile.id, @gum.id).exists?
      @rated = GumRatingRelationship.find(GumRatingRelationship.already_rated(@profile.id, @gum.id).first)
      redirect_to(edit_rating_url(@rated))
    end
    @new_rating = GumRatingRelationship.new
    
    #@gum = Gum.find(params[:gum_id])
    #@test = params[:user_id]
    #@profile = Profile.find_by_user_id(current_user.id)
    #profile_id where user_id == current_user.id
    #if GumRatingRelationship.already_rated(@profile.id, @gum.id).exists?
    #if GumRatingRelationship.already_rated(current_user.id, @gum.id).exists?
    #  @rated = GumRatingRelationship.find(GumRatingRelationship.already_rated(@profile.id, @gum.id).first)
    #        @my_string = "UMMMM..."
    #  redirect_to(edit_rating_url(@rated))
    #else
    #  @my_string = "not yet rated..."
    #end
  end
  
  def create
    @new_rating = GumRatingRelationship.new
    #@new_rating.profile_id = Profile.find_by_user_id(current_user.id)
    
    #trying to fix this (feb 22nd 2013)
    #@new_rating.profile_id = current_user.id   #### THIS IS WHY IT IS FUCKED UP, SAVING CURRENT_USER.ID AS PROFILE.ID, NOT ALWAYS THE SAME THING...
    @new_rating.profile_id = Profile.find_by_user_id(current_user.id).id
    
    #@new_rating.gum_id = params[:gum_id]
    @new_rating.gum_id = get_gum_id(params[:gum_permalink])
    @new_rating.rank_1 = params[:gum_rating_relationship][:rank_1]
    @new_rating.rank_2 = params[:gum_rating_relationship][:rank_2]
    @new_rating.rank_3 = params[:gum_rating_relationship][:rank_3]
    @new_rating.rank_4 = params[:gum_rating_relationship][:rank_4]
    @new_rating.rank_5 = params[:gum_rating_relationship][:rank_5]
    @new_rating.comment = params[:gum_rating_relationship][:comment]
    values = [@new_rating.rank_1.to_i,@new_rating.rank_2.to_i,@new_rating.rank_3.to_i,@new_rating.rank_4.to_i,@new_rating.rank_5.to_i]
    @new_rating.total = values.sum
    @new_rating.average = @new_rating.total / values.size.to_f.round(2)
    if @new_rating.save
      flash[:notice] = "New Rating created"
      #redirect_to(gum_url(@new_rating.gum_id))
      redirect_to(gum_url(get_permalink(@new_rating.gum_id)))
    else
      flash[:alert] = "New Rating Save failed :("
      @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
      @gum = Gum.find_by_permalink(params[:gum_permalink]) || not_found
      @profile = Profile.find_by_user_id(current_user.id)
      render('new')
    end
  end
  
  def update
    @changed_rating = GumRatingRelationship.find(params[:id])
#    @changed_rating.user_id = current_user.id
#    @changed_rating.gum_id = params[:gum_id]
    @changed_rating.rank_1 = params[:gum_rating_relationship][:rank_1]
    @changed_rating.rank_2 = params[:gum_rating_relationship][:rank_2]
    @changed_rating.rank_3 = params[:gum_rating_relationship][:rank_3]
    @changed_rating.rank_4 = params[:gum_rating_relationship][:rank_4]
    @changed_rating.rank_5 = params[:gum_rating_relationship][:rank_5]
=begin
    @changed_rating.gumtation = params[:gum_rating_relationship][:gumtation]
    @changed_rating.initial_gumalicious = params[:gum_rating_relationship][:initial_gumalicious]
    @changed_rating.overall_gumalicious = params[:gum_rating_relationship][:overall_gumalicious]
    @changed_rating.gumalicious_gumgevity = params[:gum_rating_relationship][:gumalicious_gumgevity]
    @changed_rating.flavoracity = params[:gum_rating_relationship][:flavoracity] 
    @changed_rating.initial_chewlasticity = params[:gum_rating_relationship][:initial_chewlasticity]
    @changed_rating.overall_chewlasticity = params[:gum_rating_relationship][:overall_chewlasticity]
    @changed_rating.chewlasticity_gumgevity = params[:gum_rating_relationship][:chewlasticity_gumgevity]
    @changed_rating.bubbability = params[:gum_rating_relationship][:bubbability]
    @changed_rating.breathalation = params[:gum_rating_relationship][:breathalation]
=end
    @changed_rating.comment = params[:gum_rating_relationship][:comment]
    #values = [@changed_rating.stat_1.to_i,@changed_rating.stat_2.to_i,@changed_rating.stat_3.to_i,@changed_rating.chewlasticity.to_i,@changed_rating.gumaliciousness.to_i,@changed_rating.gumgevity.to_i,@changed_rating.bubbability.to_i]
    values = [@changed_rating.rank_1.to_i,@changed_rating.rank_2.to_i,@changed_rating.rank_3.to_i,@changed_rating.rank_4.to_i,@changed_rating.rank_5.to_i]    
    @changed_rating.total = values.sum
    @changed_rating.average = (@changed_rating.total / values.size.to_i)
    if @changed_rating.save
    #if @rating.update_attributes(params[:rating])
      flash[:notice] = "Rating Updated"
      #redirect_to(gum_url(@changed_rating.gum_id))
      redirect_to(gum_url(get_permalink(@changed_rating.gum_id)))
    else
      flash[:alert] = "Can't save your rating the way it is..."
      @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
      #@gum = Gum.find(params[:gum_rating_relationship][:gum_id])   #  LOL... WOW, 2+ HOURS WASTED...  DON'T FORGET:  RENDER DOESN'T EXECUTE METHOD FIRST, JUST DISPLAYS PAGE AGAIN, VARIABLES LOST...
      @gum = Gum.find(@changed_rating.gum_id)
      # why not setting @profile here ?!?!
      render('edit')
    end
  end

  private
  
  def get_permalink (gum_id)
    g = Gum.find(gum_id)
    return g.permalink    
  end
  
  def get_gum_id (permalink)
    g = Gum.find_by_permalink(permalink) || not_found
    return g.id
  end
  
end
