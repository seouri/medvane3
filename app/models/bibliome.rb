class Bibliome < ActiveRecord::Base
  has_many :article_bibliomes
  has_many :articles, :through => :article_bibliomes
  has_many :author_journals
  has_many :coauthorships
  has_many :author_subjects
  has_many :author_pubtypes
  has_many :journal_subject
  has_many :journal_pubtypes
  has_many :cosubjects
  
  validates_uniqueness_of :name
  
  def status
    if built?
      "finished importing"
    else
      "imported"
    end
  end
end
