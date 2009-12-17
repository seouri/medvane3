class CreateJournals < ActiveRecord::Migration
  def self.up
    create_table :journals do |t|
      t.string :title
      t.string :abbr
    end
    add_index :journals, :title
    add_index :journals, :abbr
  end

  def self.down
    drop_table :journals
  end
end
