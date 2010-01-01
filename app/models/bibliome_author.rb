class BibliomeAuthor < ActiveRecord::Base
  belongs_to :bibliome, :counter_cache => :authors_count
  belongs_to :author

  validates_uniqueness_of :author_id, :scope => :bibliome_id

  named_scope :period, lambda {|range|
    { :conditions => "`#{range}` > 0", :order => "`#{range}` desc"}
  }
end
