class CreateBibliomePubtypes < ActiveRecord::Migration
  def self.up
    create_table :bibliome_pubtypes do |t|
      t.integer :bibliome_id
      t.integer :pubtype_id
      t.integer :one
      t.integer :five
      t.integer :ten
      t.integer :all
    end
    add_index :bibliome_pubtypes, :bibliome_id
  end

  def self.down
    drop_table :bibliome_pubtypes
  end
end
