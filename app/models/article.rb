class Article < ActiveRecord::Base
  has_many :articles_bibliomes
  has_many :bibliomes, :through => :articles_bibliomes
  belongs_to :journal
  has_many :authorships
  has_many :authors, :through => :authorships
  
  validates_associated :journal
end
