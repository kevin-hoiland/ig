class RatingsController < ApplicationController

  before_filter :authenticate_user!, :only => [:edit, :new, :create, :update]
  
  def index
    list
    render('list')
  end
  
  def list
    @search_ratings = GumRatingRelationship.with_active_gum.ransack(params[:q])
    @ratings_list = @search_ratings.result(:distinct => true).order("gum_rating_relationships.updated_at DESC").page(params[:page])
  end
  
  def show
    @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
    @rating = GumRatingRelationship.with_active_gum.find(params[:id])
    @profile = Profile.find(@rating.profile_id)
  end
  
  def per_gum
    @gum = Gum.active.find_by_permalink(params[:gum_permalink]) || not_found 
    @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
    @search_ratings = GumRatingRelationship.with_active_gum.ransack(params[:q])
    @ratings = @search_ratings.result(:distinct => true).where(:gum_id => @gum.id).order("gum_rating_relationships.updated_at DESC").page(params[:page])    
    # @ratings = Kaminari.paginate_array(GumRatingRelationship.find_all_by_gum_id(@gum.id, :order => 'created_at DESC')).page(params[:page])
  end
  
  def per_member
    @profile = Profile.find(params[:id])
    @content_legal = DynamicText.content("gum_general").order("sequence ASC")
    @search_ratings = GumRatingRelationship.with_active_gum.ransack(params[:q])
    @ratings = @search_ratings.result(:distinct => true).where(:profile_id => @profile.id).order("gum_rating_relationships.updated_at DESC").page(params[:page])
    # @ratings = Kaminari.paginate_array(GumRatingRelationship.find_all_by_profile_id(@profile.id, :order => 'created_at DESC')).page(params[:page])
  end
  
  def edit # NOTE:  expecting to always route through New first, to verify correct user etc
    @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
    @changed_rating = GumRatingRelationship.with_active_gum.find(params[:id])
    @gum = Gum.active.find(@changed_rating.gum_id) || not_found 
    unless User.find(current_user.id).profile.id == @changed_rating.profile_id
      flash[:alert] = "Come on dude, you can't edit someone else's rating, seriously, this isn't amateur hour..."
      redirect_to(ratings_url)
    end
  end
  
  def new
    @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
    @gum = Gum.active.find_by_permalink(params[:gum_permalink]) || not_found
    @profile = Profile.find_by_user_id(current_user.id)
    if GumRatingRelationship.already_rated(@profile.id, @gum.id).exists?
      @rated = GumRatingRelationship.find(GumRatingRelationship.already_rated(@profile.id, @gum.id).first)
      flash.keep(:notice)
      flash.keep(:alert)
      redirect_to(edit_rating_url(@rated))
    end
    @new_rating = GumRatingRelationship.new
  end
  
  def create
    @new_rating = GumRatingRelationship.new
    @new_rating.profile_id = Profile.find_by_user_id(current_user.id).id
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
      redirect_to(gum_url(get_permalink(@new_rating.gum_id)))
    else
      flash[:alert] = "New Rating Save failed :("
      @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
      @gum = Gum.active.find_by_permalink(params[:gum_permalink]) || not_found
      @profile = Profile.find_by_user_id(current_user.id)
      render('new')
    end
  end
  
  def update
    @changed_rating = GumRatingRelationship.find(params[:id])
    @changed_rating.rank_1 = params[:gum_rating_relationship][:rank_1]
    @changed_rating.rank_2 = params[:gum_rating_relationship][:rank_2]
    @changed_rating.rank_3 = params[:gum_rating_relationship][:rank_3]
    @changed_rating.rank_4 = params[:gum_rating_relationship][:rank_4]
    @changed_rating.rank_5 = params[:gum_rating_relationship][:rank_5]
    @changed_rating.comment = params[:gum_rating_relationship][:comment]
    values = [@changed_rating.rank_1.to_i,@changed_rating.rank_2.to_i,@changed_rating.rank_3.to_i,@changed_rating.rank_4.to_i,@changed_rating.rank_5.to_i]    
    @changed_rating.total = values.sum
    @changed_rating.average = (@changed_rating.total / values.size.to_i)
    if @changed_rating.save
      flash[:notice] = "Rating Updated"
      redirect_to(gum_url(get_permalink(@changed_rating.gum_id)))
    else
      flash[:alert] = "Sorry, you can't save your rating that way..."
      @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
      @gum = Gum.active.find(@changed_rating.gum_id) || not_found 
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
