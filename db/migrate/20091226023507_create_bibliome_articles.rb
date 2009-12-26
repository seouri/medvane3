class CreateBibliomeArticles < ActiveRecord::Migration
  def self.up
    create_table :bibliome_articles do |t|
      t.integer :bibliome_id
      t.integer :article_id
    end
    add_index :bibliome_articles, :bibliome_id
  end

  def self.down
    drop_table :bibliome_articles
  end
end
