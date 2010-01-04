class BibliomeJournal < ActiveRecord::Base
  belongs_to :bibliome
  belongs_to :journal
  
  validates_uniqueness_of :journal_id, :scope => [:bibliome_id, :year]

  named_scope :period, lambda {|range|
    { :conditions => { :year => range }, :order => "`articles_count` desc"}
  }
end
