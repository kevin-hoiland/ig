class Gum < ActiveRecord::Base

  mount_uploader :image, ImageUploader
  
  ############  attributes  ############
  attr_accessible :permalink, :title, :upc, :active, :company, :brand, :flavor, :description, :note, :country, :new_release, :discontinued, :image, as: :admin

  #  attr_searchable :upc, :company, :brand, :flavor, :description, :note, :country, :new_release, :discontinued
  #  assoc_searchable :thumbs_up #:rating_total 
  #from : http://erniemiller.org/2012/05/11/why-your-ruby-class-macros-might-suck-mine-did/
  def self.ransackable_attributes(auth_object = nil)
    super & ['upc', 'title', 'company', 'active', 'brand', 'flavor', 'country', 'description', 'new_release']
  end

  ############  validations  ############
  #  validates :upc, :length => { :within => 6..255 }, :uniqueness => true, :presence => true
  validates :permalink, :uniqueness => true, :presence => true
  
  ############  associations  ############
  has_many :gum_rating_relationships # looks like i also probably want ", :dependent => true", but not allowing gum deletions yet...
  has_many :gum_shipment_relationships
  has_many :profiles, :through => :gum_rating_relationsihps
  has_and_belongs_to_many :shipments, :join_table => :gum_shipments
  has_many :votes
  #  accepts_nested_attributes_for :gum_rating_relationships #allow_destroy => true
  
  acts_as_voteable
  
  ############  scopes  ############
  scope :empty_upc, :conditions => { :upc => "0"}
  scope :search_upc, lambda {|upc| where(["upc LIKE ?", "%#{upc}%"])}
  scope :search_company, lambda {|company| where(["company LIKE ?", "%#{company}%"])}
  # scope :sort_by_votes_up_asc, Gum.where(:brand => 'Trident').order('id ASC')
  # scope :sort_by_votes_up_desc, Gum.where(:brand => 'Trident').order('id DESC')
  
  ############  methods  ############

  def total_average_rating (gum_id)
    set = GumRatingRelationship.where(:gum_id => gum_id)
    if set.empty?
      return("0".to_i)
    else
      return(set.average(:total))
    end
    #return(set.average.sum)
    #return (set.average.sum / set.size.to_f)
  end
  
  def get_rating_averages
    set = GumRatingRelationship.where(:gum_id => self.id)
    return([set.average(:rank_1), set.average(:rank_2), set.average(:rank_3), set.average(:rank_4), set.average(:rank_5) ])
  end

end
