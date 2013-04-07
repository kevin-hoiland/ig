module RatingsHelper
  
  def get_permalink (gum_id)
    g = Gum.find(gum_id)
    return g.permalink    
  end
  
  def view_self
    Profile.find_by_user_id(current_user.id)
  end
  
end
