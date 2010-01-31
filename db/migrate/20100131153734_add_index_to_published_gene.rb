class AddIndexToPublishedGene < ActiveRecord::Migration
  def self.up
    add_index :published_genes, :article_id
  end

  def self.down
    remove_index :published_genes, :article_id
  end
end
