class DynamicText < ActiveRecord::Base
  # attr_accessible :title, :body

#  attr_accessible :location, :sequence, :size, :visible, :content # for DB Seed only...
  attr_accessible :location, :sequence, :size, :visible, :content, as: :admin
  validates_uniqueness_of :sequence, :scope => :location
  
  scope :news, :conditions => { :location => "news"}
  scope :faqs, :conditions => { :location => "faq"}
  scope :content, lambda {|page| where(["location LIKE ? AND visible = ?", "%#{page}%", "1"])}

  #scope :sequence, lambda {|sequence| {:order => sequence.flatten.first} }
  #scope :sequence, lambda {|sequence| {:order => "sequence #{sequence}"} }
end
