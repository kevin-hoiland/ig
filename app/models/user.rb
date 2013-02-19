class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, as: :admin
  # attr_accessible :title, :body
  
  validates :email, :length => { :maximum => 255 }
  
  has_one :profile
  has_many :billing
  
  acts_as_voter
  # The following line is optional, and tracks karma (up votes) for questions this user has submitted.
  # Each question has a submitter_id column that tracks the user who submitted it.
  # The option :weight value will be multiplied to any karma from that voteable model (defaults to 1).
  # You can track any voteable model.
  # has_karma(:questions, :as => :submitter, :weight => 0.5)
  
  def confirm!
    add_profile
    super
  end
  #after_create :add_profile

  
  #after_commit :add_other_info
  #after_save :add 
  #after_create :add_other_info
  #before_save :add_other_info
  
  private
  
    def add_profile
      profile = Profile.new
      profile.user_id = self.id
      profile.save  # potential failure here... hmmmmmmmm :(
      # Tell the UserMailer to send a welcome Email after save
      # UserMailer.welcome_email(@user).deliver
      UserMailer.welcome_email(self).deliver
    end
    
    
    def add_other_info
      profile = Profile.new
      profile.user_id = self.id
      profile.save
      billing = Billing.new
      billing.user_id = self.id
      billing.save
    end
    
end
