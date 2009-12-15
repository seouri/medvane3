class Journal < ActiveRecord::Base
  has_many :articles
  
  validates_uniqueness_of :title
  validates_uniqueness_of :abbr
end
