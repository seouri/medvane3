class CreateBibliomeAuthors < ActiveRecord::Migration
  def self.up
    create_table :bibliome_authors do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.integer :one, :default => 0
      t.integer :five, :default => 0
      t.integer :ten, :default => 0
      t.integer :all, :default => 0
    end
    add_index :bibliome_authors, :bibliome_id
  end

  def self.down
    drop_table :bibliome_authors
  end
end
