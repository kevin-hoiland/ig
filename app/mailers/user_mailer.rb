class UserMailer < ActionMailer::Base
  #default from: "notifications@intlgum.com"
  default from: "Intl Gum <notifications@intlgum.com>"
  
  def welcome_email(user)
    @user = user
#    @login_url  = 'http://intlgum.com/users/sign_in'
    @login_url  = new_user_session_url
    @view_self_url  = profile_url(Profile.find_by_user_id(user.id))
    @edit_self_url = edit_profile_url
    mail(to: user.email, subject: 'Welcome to My Awesome Site')
  end
   
end
