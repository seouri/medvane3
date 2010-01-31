class AddIndexToGene < ActiveRecord::Migration
  def self.up
    add_index :genes, :symbol
  end

  def self.down
    remove_index :genes, :symbol
  end
end
