class BibliomeAuthor < ActiveRecord::Base
  belongs_to :bibliome, :counter_cache => :authors_count
  belongs_to :author

  validates_uniqueness_of :author_id, :scope => :bibliome_id
end
