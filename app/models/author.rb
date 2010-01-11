class Author < ActiveRecord::Base
  has_many :bibliome_authors, :order => "year"
  has_many :bibliomes, :through => :bibliome_authors
  has_many :authorships
  has_many :articles, :through => :authorships
  has_many :author_journals
  has_many :journals, :through => :author_journals
  has_many :coauthorship
  has_many :coauthors, :through => :coauthorship, :source => :coauthor_id
  has_many :author_subjects
  has_many :subjects, :through => :author_subjects
  has_many :author_pubtypes
  has_many :pubtypes, :through => :author_pubtypes
  
  validates_uniqueness_of :fore_name, :scope => [:last_name, :suffix]
  
  def full_name
    ["#{last_name || ""}", "#{fore_name || ""}"].join(", ")
  end

  def init_name
    ["#{last_name || ""}", "#{initials || ""}"].join(" ")
  end

  def merge_with(author)
    
  end
  
  def to_l
    full_name
  end
end
