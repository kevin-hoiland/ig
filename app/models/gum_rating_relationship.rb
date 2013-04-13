class GumRatingRelationship < ActiveRecord::Base

  ############  attributes  ############
  attr_accessible :profile_id, :gum_id, :comment, :rank_1, :rank_2, :rank_3, :rank_4, :rank_5, as: :admin
  
  ############  validations  ############
  validates_uniqueness_of :profile_id, :scope => :gum_id, :message => "already rated this gum! Please edit your prior ranking, ok ;-)"
  validates :rank_1, :rank_2, :rank_3, :rank_4, :rank_5, :inclusion => 0..10
  validates :comment, :length => { :maximum => 1000 }
  
  ############  associations  ############
  belongs_to :user
  belongs_to :gum
  
  ############  scopes  ############
  scope :already_rated, lambda {|profile_id, gum_id| where(:profile_id => profile_id, :gum_id => gum_id)}
  
end
