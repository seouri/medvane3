class CreateBibliomeAuthors < ActiveRecord::Migration
  def self.up
    create_table :bibliome_authors do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.integer :one
      t.integer :five
      t.integer :ten
      t.integer :all
    end
    add_index :bibliome_authors, :bibliome_id
  end

  def self.down
    drop_table :bibliome_authors
  end
end
