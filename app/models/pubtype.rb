class Pubtype < ActiveRecord::Base
  has_many :bibliome_pubtypes, :order => "year"
  has_many :bibliomes, :through => :bibliome_pubtypes
  has_many :article_types
  has_many :articles, :through => :article_types
  has_many :author_pubtypes
  has_many :authors, :through => :author_pubtypes
  has_many :journal_pubtypes
  has_many :journals, :through => :journal_pubtypes
  
  def to_l
    term
  end
end
