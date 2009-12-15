class CreateJournals < ActiveRecord::Migration
  def self.up
    create_table :journals do |t|
      t.string :title
      t.string :abbr
      t.timestamps
    end
    add_index :journals, :title, :unique => true
    add_index :journals, :abbr, :unique => true
  end

  def self.down
    drop_table :journals
  end
end
