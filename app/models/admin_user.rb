class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable
# note, not using :registerable because we don't want just anyone signing themselves up for admin lol

  # Setup accessible (or protected) attributes for your model
#  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :password, :password_confirmation, :remember_me, as:  :admin

  # attr_accessible :title, :body
  
end
