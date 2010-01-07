class BibliomeSubject < ActiveRecord::Base
  belongs_to :bibliome
  belongs_to :subject
  
  validates_uniqueness_of :subject_id, :scope => [:bibliome_id, :year]

  named_scope :period, lambda {|range|
    { :conditions => { :year => range }, :order => "articles_count desc"}
  }
end
