class GumsController < ApplicationController

  before_filter :authenticate_user!, :only => [:vote_up, :vote_down]

  def index
    list
    render('list')
  end
  
  def list
    @content_legal = DynamicText.content("gum_general").order("sequence ASC")
     #META SEARCH:
     #@search_gums = Gum.search(params[:search])
    #
    #RANSACK WAS HERE
    @search_gums = Gum.ransack(params[:q])
    #     (from https://github.com/gregbell/active_admin/issues/1404)
    #@search_gums = Gum.search(params[:q])
    #
    #
    # META SEARCH:
    #@gums_list = @search_gums.order("updated_at DESC").page(params[:page])
    #@gums_list = @search_gums.order("updated_at DESC").page(params[:page]).per(10)
    #RANSACK WAS HERE
    @gums_list = @search_gums.result.page(params[:page])
    #@gums_list = @search_gums.result.page(params[:page]).per(10)
    #@gums_list = Gum.order("updated_at DESC").page(params[:page]).per(10)
    #@gums_list = Gum.all
    # @gums = Gum.search_upc(params[:upc]).search_company(params[:company]).order("updated_at DESC")
  end
  
  def show
    @content_legal = DynamicText.content("gum_specific").order("sequence ASC")
    #@gum = Gum.find(params[:id])
    @gum = Gum.find_by_permalink(params[:id])
    @votes_up_total = @gum.votes_for
    @votes_down_total = @gum.votes_against
    @rating_averages = @gum.get_rating_averages
    @rating_count = GumRatingRelationship.where(:gum_id => @gum.id).count
    #@gum_rating_averages = get_gum_rating_averages(@gum.id)
    #@ratings = Kaminari.paginate_array(GumRatingRelationship.find_all_by_gum_id(params[:id], :order => 'created_at DESC')).page(params[:page]).per(10)
    #@set = GumRatingRelationship.find_all_by_gum_id(params[:id], :order => 'created_at DESC')
    #@ratings = @set.page(params[:page]).per(10)
    #@ratings = GumRatingRelationship.find_all_by_gum_id(params[:id]).order("updated_at DESC").page(params[:page]).per(10)
    #@ratings = GumRatingRelationship.find_all_by_gum_id(params[:id], :order => 'created_at DESC').page(params[:page]).per(10)
    # @ratings = GumRatingRelationship.where("gum_id = ?", params[:id]).order('created_at DESC')
  end
  
  def vote_up
    gum = Gum.find_by_permalink(params[:permalink])
    if current_user.voted_for?(gum)
      flash[:alert] = "You had already voted this gum Bubble, can't vote the same way twice"
      redirect_to(gum_url(gum.permalink))
      #redirect_to(gum_url)
    elsif current_user.voted_against?(gum)
      current_user.vote_exclusively_for(gum)
      flash[:notice] = "Changed your vote from Bust to Bubble"
      redirect_to(gum_url(gum.permalink))
      #redirect_to(gum_url) 
    else
      flash[:notice] = "New Bubble Vote Counted!"
      current_user.vote_exclusively_for(gum)
      redirect_to(gum_url(gum.permalink))
    end
#   begin
#     current_user.vote_for(@post = Post.find(params[:id]))
#     render :nothing => true, :status => 200
#   rescue ActiveRecord::RecordInvalid
#     render :nothing => true, :status => 404
#   end     
  end

  def vote_down
    gum = Gum.find_by_permalink(params[:permalink])
    if current_user.voted_against?(gum)
      flash[:alert] = "You had already voted this gum Bust, can't vote the same way twice"
      redirect_to(gum_url(gum.permalink))
      #redirect_to(gum_url)
    elsif current_user.voted_for?(gum)
      current_user.vote_exclusively_against(gum)
      flash[:notice] = "Changed your vote from Bubble to Bust"
      redirect_to(gum_url(gum.permalink))
      #redirect_to(gum_url)
    else
      flash[:notice] = "New Bust Vote Counted!"
      current_user.vote_exclusively_against(gum)
      #redirect_to(gum_url)
      redirect_to(gum_url(gum.permalink))
    end         
    #current_user.vote_exclusively_against(@gum = Gum.find(params[:id]))
    #flash[:notice] = "DOWN Vote Counted!"
    #show
    #render('show')
  end
  
end
