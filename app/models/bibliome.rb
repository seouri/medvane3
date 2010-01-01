class Bibliome < ActiveRecord::Base
  has_many :bibliome_articles
  has_many :articles, :through => :bibliome_articles
  has_many :bibliome_journals
  has_many :journals, :through => :bibliome_journals
  has_many :bibliome_authors
  has_many :authors, :through => :bibliome_authors
  has_many :bibliome_subjects
  has_many :subjecst, :through => :bibliome_subjects
  #has_many :bibliome_genes
  #has_many :genes, :through => :bibliome_genes
  has_many :bibliome_pubtypes
  has_many :pubtpes, :through => :bibliome_pubtypes
  has_many :author_journals
  has_many :coauthorships
  has_many :author_subjects
  has_many :author_pubtypes
  has_many :journal_subject
  has_many :journal_pubtypes
  has_many :cosubjects
  
  validates_uniqueness_of :name
  
  named_scope :built, :conditions => {:built => true}
  def status
    if built?
      "finished importing"
    else
      "imported"
    end
  end
end
