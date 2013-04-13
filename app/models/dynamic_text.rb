class DynamicText < ActiveRecord::Base

  ############  attributes  ############
  attr_accessible :location, :sequence, :size, :visible, :content, as: :admin
  
  ############  validations  ############
  validates_uniqueness_of :sequence, :scope => :location
  
  ############  scopes  ############
  scope :news, :conditions => { :location => "news"}
  scope :faqs, :conditions => { :location => "faq"}
  scope :content, lambda {|page| where(["location LIKE ? AND visible = ?", "%#{page}%", "1"])}
  #scope :sequence, lambda {|sequence| {:order => sequence.flatten.first} }
  #scope :sequence, lambda {|sequence| {:order => "sequence #{sequence}"} }
  
end
