class Subject < ActiveRecord::Base
  has_many :bibliome_subjects, :order => "year"
  has_many :bibliomes, :through => :bibliome_subjects
  has_many :topics
  has_many :articles, :through => :topics
  has_many :mesh_trees
  has_many :mesh_ancestors
  has_many :ancestors, :through => :mesh_ancestors, :source => :ancestor
  has_many :author_subjects
  has_many :authors, :through => :author_subjects
  has_many :journal_subjects
  has_many :journals, :through => :journal_subjects
  has_many :cosubjectships
  has_many :cosubjects, :through => :cosubjectships, :source => :cosubject_id
  
  def to_l
    term
  end
end
