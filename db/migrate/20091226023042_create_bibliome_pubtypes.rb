class CreateBibliomePubtypes < ActiveRecord::Migration
  def self.up
    create_table :bibliome_pubtypes do |t|
      t.integer :bibliome_id
      t.integer :pubtype_id
      t.string :year
      t.integer :articles_count, :default => 0
    end
    add_index :bibliome_pubtypes, [:bibliome_id, :pubtype_id, :year]
    add_index :bibliome_pubtypes, [:bibliome_id, :year, :articles_count], :name => 'index_bibliome_pubtypes_on_bibliome_id_year_articles_count'
  end

  def self.down
    drop_table :bibliome_pubtypes
  end
end
