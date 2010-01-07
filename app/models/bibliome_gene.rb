class BibliomeGene < ActiveRecord::Base
  belongs_to :bibliome
  belongs_to :genes
  
  validates_uniqueness_of :gene_id, :scope => [:bibliome_id, :year]

  named_scope :period, lambda {|range|
    { :conditions => { :year => range }, :order => "articles_count desc"}
  }
end
