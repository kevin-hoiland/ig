class GumRatingRelationship < ActiveRecord::Base
  
  ############  attributes  ############
  attr_accessible :profile_id, :gum_id, :comment, :rank_1, :rank_2, :rank_3, :rank_4, :rank_5, as: :admin
  
  ############  validations  ############
  validates_uniqueness_of :profile_id, :scope => :gum_id, :message => "already rated this gum! Please edit your prior ranking, ok ;-)"
  validates :rank_1, :rank_2, :rank_3, :rank_4, :rank_5, :inclusion => { :in => 0..10, :message => "rating is missing, please rate all or none"},
              :unless => "rank_1.nil? && rank_2.nil? && rank_3.nil? && rank_4.nil? && rank_5.nil?"
  validates :comment, :length => { :maximum => 1000 }
  
  ############  associations  ############
  belongs_to :user
  belongs_to :gum
  
  ############  scopes  ############
  scope :already_rated, lambda {|profile_id, gum_id| where(:profile_id => profile_id, :gum_id => gum_id)}

  scope :with_active_gum, :include => :gum, :conditions => { 'gums.active' => true }
#  scope :with_active_gum, joins(:gums) & Gum.active
#  scope :active_gum, includes(:gum).where(:active => true)
#  scope :active_gum, lambda {|status| where(["active = ?", "%#{status}%"])}

end
