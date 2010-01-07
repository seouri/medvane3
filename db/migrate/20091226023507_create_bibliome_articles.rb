class CreateBibliomeArticles < ActiveRecord::Migration
  def self.up
    create_table :bibliome_articles do |t|
      t.integer :bibliome_id
      t.integer :article_id
      t.date :pubdate
    end
    add_index :bibliome_articles, [:bibliome_id, :pubdate, :article_id], :name => 'index_bibliome_articles_on_bibliome_id_pubdate_article_id'
  end

  def self.down
    drop_table :bibliome_articles
  end
end
