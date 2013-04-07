class Profile < ActiveRecord::Base
  
  ############  attributes  ############
  
  attr_accessible :name, :sex, :location, :age, :story
  attr_accessible :user_id, :name, :location, :age, :sex, :story, :subscriptions_created, :subscriptions_deleted, as: :admin
  
  def self.ransackable_attributes(auth_object = nil)
    super & ['name', 'location', 'brand', 'age', 'note', 'sex', 'story', 'updated_at', 'created_at']
  end    
  
  attr_accessor :reason
  
  ############  validations  ############
  
  validates :name, :length => { :within => 0..100 }
  validates_uniqueness_of :name, :allow_nil => true, :allow_blank => true
#  validates :location, :length => { :maximum => 255 }
#  validates_inclusion_of :sex, :in => ["", "Male", "Female", "Other"]
#  validates :story, :length => { :maximum => 500 } # also enforced in View form
  
  ############  associations  ############
  
  belongs_to :user
  has_many :gum_rating_relationships, :dependent => :destroy # looks like i also probably want ", :dependent => true"
  has_many :gums, :through => :gum_rating_relationships
  
  ############  scopes  ############
  
  scope :active_subscriber, where("(subscriptions_created - subscriptions_deleted) > 0")
  scope :not_subscribed, where("(subscriptions_created - subscriptions_deleted) = 0")
  # scope :subscriber, where(:subscriber => true)   
  # scope :location, lambda {|location| where(["location LIKE ?", "%#{location}%"])}
  # scope :name, lambda {|name| where(["alias LIKE ?", "%#{name}%"])}
  # scope :search_email, lambda {|email| where(["email LIKE ?", "%#{email}%"])}

end
