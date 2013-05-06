class Gum < ActiveRecord::Base

#  default_scope where(:active => true)
  
  mount_uploader :image, ImageUploader
  
  ############  attributes  ############
  attr_accessible :permalink, :title, :upc, :active, :company, :brand, :flavor, :description, :note, :country, :new_release, :discontinued, :image, as: :admin
    
  #from : http://erniemiller.org/2012/05/11/why-your-ruby-class-macros-might-suck-mine-did/
  def self.ransackable_attributes(auth_object = nil)
#    super & ['upc', 'title', 'company', 'active', 'brand', 'flavor', 'country', 'description', 'new_release', 'testing', 'order_by_score_asc', 'order_by_score_desc', 'score', 'omg']
    super & ['upc', 'title', 'company', 'active', 'brand', 'flavor', 'country', 'description', 'new_release']
  end
  
  ############  validations  ############
  #  validates :upc, :length => { :within => 6..255 }, :uniqueness => true, :presence => true
  validates :permalink, :uniqueness => true, :presence => true
  
  ############  associations  ############
  has_many :gum_rating_relationships # looks like i also probably want ", :dependent => true", but not allowing gum deletions yet...
  has_many :gum_shipment_relationships
  has_many :profiles, :through => :gum_rating_relationships #this was spelled wrong!?!?!?!
  has_and_belongs_to_many :shipments, :join_table => :gum_shipments
  has_many :votes
  #  accepts_nested_attributes_for :gum_rating_relationships #allow_destroy => true
  
  acts_as_voteable
  
  ############  scopes  ############
  scope :empty_upc, :conditions => [ 'upc = 0 OR upc = null' ]
  scope :no_image, :conditions => { :image => "intl_gum_coming_soon_bubble.png" }
  scope :no_description, :conditions => { :description => "" }
  scope :inactive, :conditions => { :active => false }
  scope :search_upc, lambda {|upc| where(["upc LIKE ?", "%#{upc}%"])}
  scope :search_company, lambda {|company| where(["company LIKE ?", "%#{company}%"])}  
  scope :active, where(:active => true)
  
#  scope_ransackable :omg
#  scope :omg, lambda {|direction| joins(:votes).group(:voteable_id).order("sum(votes.vote) #{direction}") }
# https://github.com/ernie/ransack/issues/61
# http://stackoverflow.com/questions/3472669/ordering-objects-by-a-sum-of-has-many-association
# https://github.com/gregbell/active_admin/pull/1994
  
  ############  methods  ############
  
  def total_average_rating_to_score (gum_id)
    set = GumRatingRelationship.where(:gum_id => gum_id)
    if set.empty?
      return("".to_s)
    else
      return(((set.average(:total)).floor)*2).to_s+"%"
    end
  end
  
  def to_score
    (self.to_i*2).to_s+"%"
  end

=begin  
  def get_gum_list_rating(gum_id, rating_type)
    ranking_set = GumRatingRelationship.where(:gum_id => gum_id)
    case rating_type
      when "rank_1"
        @rank_1_average = ranking_set.average(:rank_1)
        return ranking_set.average(:rank_1)
      when "rank_2"
        return ranking_set.average(:rank_2)
      when "rank_3"
        return ranking_set.average(:rank_3)
      when "rank_4"
        return ranking_set.average(:rank_4)
      when "rank_5"
        return ranking_set.average(:rank_5)
    end      
  end
=end
  
#  def rank_1_average
#    GumRatingRelationship.where(:gum_id => self.id).average(:rank_1)
#    GumRatingRelationship.average :rank_1, :conditions => ['gum_id = ?', self.id]
#  end
    
  def get_rating_averages
    set = GumRatingRelationship.where(:gum_id => self.id)
    return([set.average(:rank_1), set.average(:rank_2), set.average(:rank_3), set.average(:rank_4), set.average(:rank_5) ])
  end
  
end
