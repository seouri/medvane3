class CreateArticlesBibliomes < ActiveRecord::Migration
  def self.up
    create_table :articles_bibliomes, :id => false do |t|
      t.integer :article_id
      t.integer :bibliome_id
    end
  end

  def self.down
    drop_table :articles_bibliomes
  end
end
