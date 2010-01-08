class CreateJournalPubtypes < ActiveRecord::Migration
  def self.up
    create_table :journal_pubtypes do |t|
      t.integer :bibliome_id
      t.integer :journal_id
      t.integer :pubtype_id
      t.string :year
      t.integer :total, :default => 0
    end
    add_index :journal_pubtypes, [:bibliome_id, :journal_id, :year, :pubtype_id], :name => 'index_journal_pubtypes_on_bibliome_journal_year_pubtype'
    add_index :journal_pubtypes, [:bibliome_id, :pubtype_id, :year, :total], :name => 'index_journal_pubtypes_on_bibliome_id_pubtype_id_year_total'
    add_index :journal_pubtypes, [:bibliome_id, :journal_id, :year, :total], :name => 'index_journal_pubtypes_on_bibliome_id_journal_id_year_total'
  end

  def self.down
    drop_table :journal_pubtypes
  end
end
