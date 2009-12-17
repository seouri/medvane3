class Subject < ActiveRecord::Base
  has_many :topics
  has_many :articles, :through => :topics
  has_many :mesh_trees
end
