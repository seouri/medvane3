class CreateBibliomes < ActiveRecord::Migration
  def self.up
    create_table :bibliomes do |t|
      t.string :name
      t.text :query
      t.integer :all_articles_count,  :default => 0
      t.integer :all_journals_count,  :default => 0
      t.integer :all_authors_count,   :default => 0
      t.integer :all_subjects_count,  :default => 0
      t.integer :all_genes_count,     :default => 0
      t.integer :all_pubtypes_count,  :default => 0
      t.integer :one_articles_count,  :default => 0
      t.integer :one_journals_count,  :default => 0
      t.integer :one_authors_count,   :default => 0
      t.integer :one_subjects_count,  :default => 0
      t.integer :one_genes_count,     :default => 0
      t.integer :one_pubtypes_count,  :default => 0
      t.integer :five_articles_count, :default => 0
      t.integer :five_journals_count, :default => 0
      t.integer :five_authors_count,  :default => 0
      t.integer :five_subjects_count, :default => 0
      t.integer :five_genes_count,    :default => 0
      t.integer :five_pubtypes_count, :default => 0
      t.integer :ten_articles_count,  :default => 0
      t.integer :ten_journals_count,  :default => 0
      t.integer :ten_authors_count,   :default => 0
      t.integer :ten_subjects_count,  :default => 0
      t.integer :ten_genes_count,     :default => 0
      t.integer :ten_pubtypes_count,  :default => 0
      t.integer :total_articles,      :default => 0
      t.integer :hits,                :default => 0
      t.boolean :built,               :default => false
      t.datetime :started_at
      t.datetime :built_at
      t.datetime :delete_at
      t.timestamps
    end
    add_index :bibliomes, :name, :unique => true
    add_index :bibliomes, [:built, :built_at]
    add_index :bibliomes, :hits
  end

  def self.down
    drop_table :bibliomes
  end
end
