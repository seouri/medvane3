class CreateBibliomes < ActiveRecord::Migration
  def self.up
    create_table :bibliomes do |t|
      t.string :name
      t.text :query
      t.integer :articles_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :bibliomes
  end
end
