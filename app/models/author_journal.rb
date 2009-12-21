class AuthorJournal < ActiveRecord::Base
  belongs_to :bibliome
  belongs_to :author
  belongs_to :journal
end
