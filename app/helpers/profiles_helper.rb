module ProfilesHelper
  def view_self
    Profile.find_by_user_id(current_user.id)
  end
  
  def viewing_self?(viewed_user)
    viewed_user.user_id == current_user.id
  end
  
  def subscriber?
    # Note, potential error here if not logged in, Profile will be NILL ;-)  Should always previously verify user_signed_in?
    p = Profile.find_by_user_id(current_user.id)
    return p.subscriptions_created > p.subscriptions_deleted
  end
  
  def subscription_count
    p = Profile.find_by_user_id(current_user.id)
    return p.subscriptions_created - p.subscriptions_deleted
  end
  
end
