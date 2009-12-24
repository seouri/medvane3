class MeshAncestor < ActiveRecord::Base
  belongs_to :subject
  belongs_to :ancestor, :class_name => "Subject", :foreign_key => "ancestor_id"
end
