class BibliomeArticle < ActiveRecord::Base
  belongs_to :bibliome, :counter_cache => :all_articles_count
  belongs_to :article, :counter_cache => :bibliomes_count
  
  validates_uniqueness_of :article_id, :scope => :bibliome_id
  
  named_scope :period, lambda {|range|
    { :order => "pubdate desc"}
  }
end
