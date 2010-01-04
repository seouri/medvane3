class CreateBibliomeJournals < ActiveRecord::Migration
  def self.up
    create_table :bibliome_journals do |t|
      t.integer :bibliome_id
      t.integer :journal_id
      t.string :year
      t.integer :articles_count, :default => 0
    end
    add_index :bibliome_journals, [:bibliome_id, :articles_count]
    add_index :bibliome_journals, [:bibliome_id, :year, :journal_id]
  end

  def self.down
    drop_table :bibliome_journals
  end
end
