class CreateGenes < ActiveRecord::Migration
  def self.up
    create_table :genes do |t|
      t.integer :taxonomy_id
      t.string :symbol
    end
  end

  def self.down
    drop_table :genes
  end
end
