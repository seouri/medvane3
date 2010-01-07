class BibliomeAuthor < ActiveRecord::Base
  belongs_to :bibliome
  belongs_to :author

  validates_uniqueness_of :author_id, :scope => [:bibliome_id, :year]

  named_scope :period, lambda {|range|
    { :conditions => { :year => range }, :order => "articles_count desc"}
  }
end
