class CreateCoauthorships < ActiveRecord::Migration
  def self.up
    create_table :coauthorships do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.integer :coauthor_id
      t.string :year
      t.integer :first
      t.integer :last
      t.integer :middle
      t.integer :total
    end
    add_index :coauthorships, [:bibliome_id, :author_id]
  end

  def self.down
    drop_table :coauthorships
  end
end
