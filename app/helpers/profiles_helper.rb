module ProfilesHelper
  def view_self
    Profile.find_by_user_id(current_user.id)
  end
  
  def viewing_self?(viewed_user)
    viewed_user.user_id == current_user.id
  end
  
  def subscriber?
    p = Profile.find_by_user_id(current_user.id) # ERROR HERE, IF NOT LOGGED IN!!!! NILL ;-)  Please don't call unless previously verifying user_signed_in?
    return p.subscriptions_created > p.subscriptions_deleted
  end
  
  def subscription_count
    p = Profile.find_by_user_id(current_user.id)
    return p.subscriptions_created - p.subscriptions_deleted
  end
  
end
