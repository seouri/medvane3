class BibliomePubtype < ActiveRecord::Base
  belongs_to :bibliome
  belongs_to :pubtype
  
  validates_uniqueness_of :pubtype_id, :scope => [:bibliome_id, :year]

  named_scope :period, lambda {|range|
    { :conditions => { :year => range }, :order => "`articles_count` desc"}
  }
end
