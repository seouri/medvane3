class CreateArticlesBibliomes < ActiveRecord::Migration
  def self.up
    create_table :articles_bibliomes do |t|
      t.integer :article_id
      t.integer :bibliome_id
    end
    add_index :articles_bibliomes, [:bibliome_id, :article_id], :unique => true
  end

  def self.down
    drop_table :articles_bibliomes
  end
end
