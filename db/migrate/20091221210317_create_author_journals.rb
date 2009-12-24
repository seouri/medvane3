class CreateAuthorJournals < ActiveRecord::Migration
  def self.up
    create_table :author_journals do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.integer :journal_id
      t.string :year
      t.integer :first, :default => 0
      t.integer :last, :default => 0
      t.integer :middle, :default => 0
      t.integer :total, :default => 0
    end
    add_index :author_journals, [:bibliome_id, :author_id, :year]
    add_index :author_journals, [:bibliome_id, :journal_id, :year]
  end

  def self.down
    drop_table :author_journals
  end
end
