class AdminUser < ActiveRecord::Base

  ############  modules  ############
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable
         # note, not using :registerable because we don't want just anyone signing themselves up for admin lol

  ############  attributes  ############
  attr_accessible :email, :password, :password_confirmation, :remember_me, as:  :admin
  
end
