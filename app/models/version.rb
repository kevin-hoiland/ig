class Version < ActiveRecord::Base

  ############  attributes  ############
  
  attr_accessible :number, :released_at, :notes, as: :admin
  
  ############  validations  ############
  
  validates :number, :presence => true, :length => { :maximum => 10 }, :uniqueness => true
  validates :notes, :length => { :within => 0..2000 }
  validates :released_at, :presence => true

  ############  scopes  ############
      
  scope :search_notes, lambda {|notes| where(["notes LIKE ?", "%#{notes}%"])}
  
end
