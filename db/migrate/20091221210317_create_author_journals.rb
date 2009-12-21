class CreateAuthorJournals < ActiveRecord::Migration
  def self.up
    create_table :author_journals do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.integer :journal_id
      t.string :year
      t.integer :first
      t.integer :last
      t.integer :middle
      t.integer :total
    end
    add_index :author_journals, [:bibliome_id, :author_id]
    add_index :author_journals, [:bibliome_id, :journal_id]
  end

  def self.down
    drop_table :author_journals
  end
end
