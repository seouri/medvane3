class CreateBibliomeAuthors < ActiveRecord::Migration
  def self.up
    create_table :bibliome_authors do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.string :year
      t.integer :articles_count, :default => 0
    end
    add_index :bibliome_authors, [:bibliome_id, :year, :author_id]
    add_index :bibliome_authors, [:bibliome_id, :year, :articles_count], :name => 'index_bibliome_authors_on_bibliome_id_year_articles_count'
  end

  def self.down
    drop_table :bibliome_authors
  end
end
