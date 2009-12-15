class ArticlesBibliome < ActiveRecord::Base
  belongs_to :bibliome, :counter_cache => :articles_count
  belongs_to :articles, :counter_cache => :bibliomes_count
end
