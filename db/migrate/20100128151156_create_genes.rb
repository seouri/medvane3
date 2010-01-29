class CreateGenes < ActiveRecord::Migration
  def self.up
    create_table :genes do |t|
      t.integer :taxonomy_id
      t.string :symbol
    end
    add_index :genes, :symbol
  end

  def self.down
    drop_table :genes
  end
end
