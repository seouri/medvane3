class BibliomePubtype < ActiveRecord::Base
  belongs_to :bibliome, :counter_cache => :pubtypes_count
  belongs_to :pubtype
  
  validates_uniqueness_of :pubtype_id, :scope => :bibliome_id
end
