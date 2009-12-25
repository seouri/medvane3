class CreateJournalPubtypes < ActiveRecord::Migration
  def self.up
    create_table :journal_pubtypes do |t|
      t.integer :bibliome_id
      t.integer :journal_id
      t.integer :pubtype_id
      t.string :year
      t.integer :articles, :default => 0
    end
    add_index :journal_pubtypes, [:bibliome_id, :journal_id, :pubtype_id, :year], :name => 'index_journal_pubtypes_on_bibliome_journal_pubtype_id_and_year'
    add_index :journal_pubtypes, [:bibliome_id, :pubtype_id, :journal_id, :year], :name => 'index_journal_pubtypes_on_bibliome_pubtype_journal_id_and_year'
  end

  def self.down
    drop_table :journal_pubtypes
  end
end
