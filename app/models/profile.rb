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
  validates :location, :length => { :maximum => 100 }
  validates :age, :length => { :maximum => 100 }
  # validates :sex, :length => { :maximum => 100 }
  # validates_inclusion_of :sex, :in => ["", "Male", "Female", "Other"]
  validates :story, :length => { :maximum => 1000 }

  ############  associations  ############
  
  belongs_to :user
  has_many :gum_rating_relationships, :dependent => :destroy
  has_many :gums, :through => :gum_rating_relationships
  
  ############  scopes  ############
  
  scope :active_subscriber, where("(subscriptions_created - subscriptions_deleted) > 0")
  scope :not_subscribed, where("(subscriptions_created - subscriptions_deleted) = 0")
  # scope :subscriber, where(:subscriber => true)   
  # scope :location, lambda {|location| where(["location LIKE ?", "%#{location}%"])}
  # scope :name, lambda {|name| where(["alias LIKE ?", "%#{name}%"])}
  # scope :search_email, lambda {|email| where(["email LIKE ?", "%#{email}%"])}

  ############  methods  ############
  
  def get_rating_averages
    set = GumRatingRelationship.with_active_gum.where(:profile_id => self.id)
    return([set.average(:rank_1), set.average(:rank_2), set.average(:rank_3), set.average(:rank_4), set.average(:rank_5) ])
  end
  
end
