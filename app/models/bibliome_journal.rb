class BibliomeJournal < ActiveRecord::Base
  belongs_to :bibliome, :counter_cache => :journals_count
  belongs_to :journal
  
  validates_uniqueness_of :journal_id, :scope => :bibliome_id
end
