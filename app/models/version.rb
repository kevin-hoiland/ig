class Version < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :number, :released_at, :notes, as: :admin
  
  validates :number, :presence => true, :length => { :maximum => 5 }, :uniqueness => true
  validates :notes, :length => { :within => 0..2000 }
    
  scope :search_notes, lambda {|notes| where(["notes LIKE ?", "%#{notes}%"])}
  
end
