class CreatePublishedGenes < ActiveRecord::Migration
  def self.up
    create_table :published_genes do |t|
      t.integer :article_id
      t.integer :gene_id
    end
  end

  def self.down
    drop_table :published_genes
  end
end
