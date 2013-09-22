module RatingsHelper
  
  def get_permalink (gum_id)
    g = Gum.find(gum_id)
    return g.permalink    
  end
  
  def get_rating_count (gum_id)
    ratings_count = GumRatingRelationship.with_active_gum.find_all_by_gum_id(gum_id).count
  end
  
  def get_gum (gum_id)
    return Gum.find(gum_id)
  end
  
  def get_rating_user (profile_user_id)
    User.find(profile_user_id)
  end
  
  def get_profile_from_rating (profile_id)
    Profile.find(profile_id)
  end
  
  def view_self
    # Note, potential error here if not logged in, Profile will be NILL ;-)  Should always previously verify user_signed_in?
    Profile.find_by_user_id(current_user.id)
  end
  
end
