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
    add_index :coauthorships, [:bibliome_id, :author_id, :coauthor_id, :year], :name => 'index_coauthorships_on_bibliome_author_coauthor_id_and_year'
  end

  def self.down
    drop_table :coauthorships
  end
end
