class Subject < ActiveRecord::Base
  has_many :topics
  has_many :articles, :through => :topics
  has_many :mesh_trees
  has_many :author_subjects
  has_many :authors, :through => :author_subjects
  has_many :journal_subjects
  has_many :journals, :through => :journal_subjects
  has_many :cosubjectships
  has_many :cosubjects, :through => :cosubjectships, :source => :cosubject_id
end
