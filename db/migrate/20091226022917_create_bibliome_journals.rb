class CreateBibliomeJournals < ActiveRecord::Migration
  def self.up
    create_table :bibliome_journals do |t|
      t.integer :bibliome_id
      t.integer :journal_id
      t.string :year
      t.integer :articles_count, :default => 0
    end
    add_index :bibliome_journals, [:bibliome_id, :year, :articles_count], :name => 'index_bibliome_journals_on_bibliome_id_year_articles_count'
    add_index :bibliome_journals, [:bibliome_id, :journal_id, :year]
  end

  def self.down
    drop_table :bibliome_journals
  end
end
