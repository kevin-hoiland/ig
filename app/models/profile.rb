class Profile < ActiveRecord::Base

  attr_accessible :name, :sex, :location, :born, :story
  attr_accessible :user_id, :name, :location, :born, :sex, :story, as: :admin
  
  attr_accessor :reason
  
  validates :name, :length => { :within => 0..100 }
  validates_uniqueness_of :name, :allow_nil => true, :allow_blank => true
  
  def self.ransackable_attributes(auth_object = nil)
    super & ['name', 'location', 'brand', 'born', 'note', 'sex', 'story']
  end
  
#  validates :location, :length => { :within => 0..100 }
#  validates :story, :length => { :within => 0..2000 }
  
  belongs_to :user
  #has_one :billing
  has_many :gum_rating_relationships # looks like i also probably want ", :dependent => true"
  has_many :gums, :through => :gum_rating_relationships
  
  scope :active_subscriber, where("(subscriptions_created - subscriptions_deleted) > 0")
  scope :not_subscribed, where("(subscriptions_created - subscriptions_deleted) = 0")
  #after_create :add_billing
  
  #private
  
  #def add_billing
  #  billing = Billing.new
  #  billing.user_id = self.user_id
  #  billing.save
  #end
  
  
#  scope :location, lambda {|location| where(["location LIKE ?", "%#{location}%"])}
#  scope :name, lambda {|name| where(["alias LIKE ?", "%#{name}%"])}
#  scope :search_email, lambda {|email| where(["email LIKE ?", "%#{email}%"])}
#  scope :subscriber, where(:subscriber => true) 
  
end
