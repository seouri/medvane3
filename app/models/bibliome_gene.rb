class BibliomeGene < ActiveRecord::Base
  belongs_to :bibliome, :counter_cache => :genes_count
  belongs_to :genes
  
  validates_uniqueness_of :gene_id, :scope => :bibliome_id

  named_scope :period, lambda {|range|
    { :conditions => "`#{range}` > 0", :order => "`#{range}` desc"}
  }
end
