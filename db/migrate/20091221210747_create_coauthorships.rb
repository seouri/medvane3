class CreateCoauthorships < ActiveRecord::Migration
  def self.up
    create_table :coauthorships do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.integer :coauthor_id
      t.string :year
      t.integer :first, :default => 0
      t.integer :last, :default => 0
      t.integer :middle, :default => 0
      t.integer :total, :default => 0
    end
    add_index :coauthorships, [:bibliome_id, :author_id, :year, :coauthor_id], :name => 'index_coauthorships_on_bibliome_id_author_id_year_coauthor_id'
    add_index :coauthorships, [:bibliome_id, :author_id, :year, :total], :name => 'index_coauthorships_on_bibliome_id_author_id_year_total'
  end

  def self.down
    drop_table :coauthorships
  end
end
