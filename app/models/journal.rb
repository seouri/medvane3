class Journal < ActiveRecord::Base
  has_many :articles
  
  validates_uniqueness_of :title, :scope => :abbr
  validates_uniqueness_of :abbr, :scope => :title
end
