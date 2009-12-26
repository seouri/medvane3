class CreateBibliomeGenes < ActiveRecord::Migration
  def self.up
    create_table :bibliome_genes do |t|
      t.integer :bibliome_id
      t.integer :gene_id
      t.integer :one
      t.integer :five
      t.integer :ten
      t.integer :all
    end
    add_index :bibliome_genes, :bibliome_id
  end

  def self.down
    drop_table :bibliome_genes
  end
end
