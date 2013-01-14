module RatingsHelper
  
  def get_permalink (gum_id)
    g = Gum.find(gum_id)
    return g.permalink    
  end
  
end
