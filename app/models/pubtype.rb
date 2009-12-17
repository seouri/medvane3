class Pubtype < ActiveRecord::Base
  has_many :article_types
  has_many :articles, :through => :article_types
end
