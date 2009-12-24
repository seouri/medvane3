class Cosubjectship < ActiveRecord::Base
  belongs_to :bibliome
  belongs_to :subject
  belongs_to :cosubject, :class_name => "Subject", :foreign_key => "cosubject_id"
end
