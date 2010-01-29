class Article < ActiveRecord::Base
  has_many :bibliome_articles
  has_many :bibliomes, :through => :bibliome_articles
  belongs_to :journal
  has_many :authorships
  has_many :authors, :through => :authorships
  has_many :topics
  has_many :subjects, :through => :topics
  has_many :article_types
  has_many :pubtypes, :through => :article_types
  has_many :published_genes
  has_many :genes, :through => :published_genes, :include => :taxonomy
  
  validates_associated :journal
end
