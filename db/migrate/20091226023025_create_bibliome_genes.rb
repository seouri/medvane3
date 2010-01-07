class CreateBibliomeGenes < ActiveRecord::Migration
  def self.up
    create_table :bibliome_genes do |t|
      t.integer :bibliome_id
      t.integer :gene_id
      t.string :year
      t.integer :articles_count, :default => 0
    end
    add_index :bibliome_genes, [:bibliome_id, :year, :gene_id]
    add_index :bibliome_genes, [:bibliome_id, :year, :articles_count]
  end

  def self.down
    drop_table :bibliome_genes
  end
end
