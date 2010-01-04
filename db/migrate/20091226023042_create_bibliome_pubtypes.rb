class CreateBibliomePubtypes < ActiveRecord::Migration
  def self.up
    create_table :bibliome_pubtypes do |t|
      t.integer :bibliome_id
      t.integer :pubtype_id
      t.string :year
      t.integer :articles_count, :default => 0
    end
    add_index :bibliome_pubtypes, [:bibliome_id, :articles_count]
    add_index :bibliome_pubtypes, [:bibliome_id, :year, :pubtype_id]
  end

  def self.down
    drop_table :bibliome_pubtypes
  end
end
