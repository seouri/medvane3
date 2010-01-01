class BibliomeSubject < ActiveRecord::Base
  belongs_to :bibliome, :counter_cache => :subjects_count
  belongs_to :subject
  
  validates_uniqueness_of :subject_id, :scope => :bibliome_id

  named_scope :period, lambda {|range|
    { :conditions => "`#{range}` > 0", :order => "`#{range}` desc"}
  }
end
