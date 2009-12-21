class CreateJournalPubtypes < ActiveRecord::Migration
  def self.up
    create_table :journal_pubtypes do |t|
      t.integer :bibliome_id
      t.integer :journal_id
      t.integer :pubtype_id
      t.string :year
      t.integer :articles
    end
    add_index :journal_pubtypes, [:bibliome_id, :journal_id]
    add_index :journal_pubtypes, [:bibliome_id, :pubtype_id]
  end

  def self.down
    drop_table :journal_pubtypes
  end
end
