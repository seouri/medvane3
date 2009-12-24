class ArticleBibliome < ActiveRecord::Base
  belongs_to :bibliome, :counter_cache => :articles_count
  belongs_to :article, :counter_cache => :bibliomes_count
  
  validates_uniqueness_of :article_id, :scope => :bibliome_id
end
