class Bibliome < ActiveRecord::Base
  has_many :bibliome_articles
  has_many :articles, :through => :bibliome_articles
  has_many :journals, :class_name => "BibliomeJournal", :include => :journal
  has_many :authors, :class_name => "BibliomeAuthor", :include => :author
  has_many :subjects, :class_name => "BibliomeSubject", :include => :subject
  #has_many :genes, :class_name => "BibliomeGene", :include => :gene
  has_many :pubtypes, :class_name => "BibliomePubtype", :include => :pubtype
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
