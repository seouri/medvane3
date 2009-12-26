class CreateBibliomes < ActiveRecord::Migration
  def self.up
    create_table :bibliomes do |t|
      t.string :name
      t.text :query
      t.integer :articles_count,  :default => 0
      t.integer :journals_count,  :default => 0
      t.integer :authors_count,   :default => 0
      t.integer :subjects_count,  :default => 0
      t.integer :genes_count,     :default => 0
      t.integer :pubtypes_count,  :default => 0
      t.boolean :built,           :default => false
      t.datetime :started_at
      t.datetime :built_at
      t.datetime :delete_at
      t.timestamps
    end
    add_index :bibliomes, :name, :unique => true
  end

  def self.down
    drop_table :bibliomes
  end
end
