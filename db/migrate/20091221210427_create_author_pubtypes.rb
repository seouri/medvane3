class CreateAuthorPubtypes < ActiveRecord::Migration
  def self.up
    create_table :author_pubtypes do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.integer :pubtype_id
      t.string :year
      t.integer :first, :default => 0
      t.integer :last, :default => 0
      t.integer :middle, :default => 0
      t.integer :total, :default => 0
    end
    add_index :author_pubtypes, [:bibliome_id, :author_id, :year, :pubtype_id], :name => 'index_author_pubtypes_on_bibliome_id_author_id_year_pubtype_id'
    add_index :author_pubtypes, [:bibliome_id, :pubtype_id, :year, :total], :name => 'index_author_pubtypes_on_bibliome_id_pubtype_id_year_total'
    add_index :author_pubtypes, [:bibliome_id, :author_id, :year, :total], :name => 'index_author_pubtypes_on_bibliome_id_author_id_year_total'
  end

  def self.down
    drop_table :author_pubtypes
  end
end
