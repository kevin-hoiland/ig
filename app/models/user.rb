class User < ActiveRecord::Base

  ############  modules  ############
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  ############  attributes  ############

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, as: :admin
  
  ############  validations  ############

  validates :email, :length => { :maximum => 255 }

  ############  associations  ############
    
  has_one :profile
  has_many :billing
  has_many :payment
  
  ########################################
  
  acts_as_voter
  # The following line is optional, and tracks karma (up votes) for questions this user has submitted.
  # Each question has a submitter_id column that tracks the user who submitted it.
  # The option :weight value will be multiplied to any karma from that voteable model (defaults to 1).
  # You can track any voteable model.
  # has_karma(:questions, :as => :submitter, :weight => 0.5)
  
  def confirm!
    # add if else here in case user already existed and is updating/changing data (email etc),
    # shouldn't add_profile again if profile already exists.  can determine with a user db 'nil' value...
    unless self.profile
      add_profile
    end
    super
  end
  #after_create :add_profile
  
  private
  
    def add_profile
      profile = Profile.new
      profile.user_id = self.id
      profile.save  # potential failure here... hmmmmmmmm :(
      # Tell the UserMailer to send a welcome Email after save
      # UserMailer.welcome_email(@user).deliver
      UserMailer.welcome_email(self).deliver
    end
    
end
