class CreateBibliomes < ActiveRecord::Migration
  def self.up
    create_table :bibliomes do |t|
      t.string :name
      t.text :query
      t.integer :articles_count, :default => 0
      t.boolean :built, :default => false
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
