class CreateArticleBibliomes < ActiveRecord::Migration
  def self.up
    create_table :article_bibliomes do |t|
      t.integer :article_id
      t.integer :bibliome_id
    end
    add_index :article_bibliomes, [:bibliome_id, :article_id], :unique => true
  end

  def self.down
    drop_table :article_bibliomes
  end
end
