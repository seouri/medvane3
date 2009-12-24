class Article < ActiveRecord::Base
  has_many :article_bibliomes
  has_many :bibliomes, :through => :article_bibliomes
  belongs_to :journal
  has_many :authorships
  has_many :authors, :through => :authorships
  has_many :topics
  has_many :subjects, :through => :topics
  has_many :article_types
  has_many :pubtypes, :through => :article_types
  
  validates_associated :journal
end
