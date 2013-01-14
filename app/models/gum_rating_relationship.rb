class GumRatingRelationship < ActiveRecord::Base
    # attr_accessible :title, :body

    # Active Record way claims intellegence belons in models, not in DB
    #    thus foriegn key constraints not in DB, but model enforces data integerity
  #  validates :user_id, :uniqueness => true
  #  validates :gum_id, :uniqueness => true

  #  validates_uniqueness_of :user_id, :scope => :gum_id

  #  accepts_nested_attributes_for :gums

  attr_accessible :profile_id, :gum_id, :comment, :gumtation, :initial_gumalicious, :overall_gumalicious,
                  :gumalicious_gumgevity, :flavoracity, :initial_chewlasticity, :overall_chewlasticity, 
                  :chewlasticity_gumgevity, :bubbability, :breathalation, as: :admin
  
  #belongs_to :profile
  belongs_to :user
  belongs_to :gum

  # validates_uniqueness_of :profile_id, :scope => :gum_id, :message => "already rated this gum! Please edit your prior ranking, ok ;-)" # :on => :create, 
  validates_uniqueness_of :profile_id, :scope => :gum_id, :message => "already rated this gum! Please edit your prior ranking, ok ;-)"
  #validates :chewlasticity, :gumaliciousness, :gumgevity, :bubbability, :stat_1, :stat_2, :stat_3, :inclusion => 0..10
  validates :gumtation, :initial_gumalicious, :overall_gumalicious, :gumalicious_gumgevity, :flavoracity, 
            :initial_chewlasticity, :overall_chewlasticity, :chewlasticity_gumgevity, :bubbability, :breathalation, 
            :inclusion => 0..10
                  
  scope :already_rated, lambda {|profile_id, gum_id| where(:profile_id => profile_id, :gum_id => gum_id)}
  
  
#  def get_gum_rating_averages (gum_id)
#    set = self.where(:gum_id => gum_id)
#    return set.stat_1.average
#  end
  
end
