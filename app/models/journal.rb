class Journal < ActiveRecord::Base
  has_many :bibliome_journals
  has_many :bibliomes, :through => :bibliome_journals
  has_many :articles
  has_many :author_journals
  has_many :authors, :through => :author_journals
  has_many :journal_subjects
  has_many :subjects, :through => :journal_subjects
  has_many :journal_pubtypes
  has_many :pubtypes, :through => :journal_pubtypes
  
  validates_uniqueness_of :title, :scope => :abbr
  validates_uniqueness_of :abbr, :scope => :title
  
  def to_l
    abbr
  end
end
