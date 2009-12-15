class Bibliome < ActiveRecord::Base
  has_many :articles_bibliomes
  has_many :articles, :through => :articles_bibliomes
  
  validates_uniqueness_of :name
  
  def status
    if built?
      "Built"
    else
      "Working"
    end
  end
end
