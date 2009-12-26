class CreateBibliomeJournals < ActiveRecord::Migration
  def self.up
    create_table :bibliome_journals do |t|
      t.integer :bibliome_id
      t.integer :journal_id
      t.integer :one
      t.integer :five
      t.integer :ten
      t.integer :all
    end
    add_index :bibliome_journals, :bibliome_id
  end

  def self.down
    drop_table :bibliome_journals
  end
end
