class CreateAuthorPubtypes < ActiveRecord::Migration
  def self.up
    create_table :author_pubtypes do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.integer :pubtype_id
      t.string :year
      t.integer :first
      t.integer :last
      t.integer :middle
      t.integer :total
    end
    add_index :author_pubtypes, [:bibliome_id, :author_id]
    add_index :author_pubtypes, [:bibliome_id, :pubtype_id]
  end

  def self.down
    drop_table :author_pubtypes
  end
end
