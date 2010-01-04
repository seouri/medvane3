class CreateBibliomeAuthors < ActiveRecord::Migration
  def self.up
    create_table :bibliome_authors do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.string :year
      t.integer :articles_count, :default => 0
    end
    add_index :bibliome_authors, [:bibliome_id, :articles_count]
    add_index :bibliome_authors, [:bibliome_id, :year, :author_id]
  end

  def self.down
    drop_table :bibliome_authors
  end
end
