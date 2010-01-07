class BibliomeJournal < ActiveRecord::Base
  belongs_to :bibliome
  belongs_to :journal
  has_many :author_journals
  has_many :journal_subjects
  has_many :journal_pubtypes
  
  validates_uniqueness_of :journal_id, :scope => [:bibliome_id, :year]

  named_scope :period, lambda {|range|
    { :conditions => { :year => range }, :order => "articles_count desc"}
  }
end
