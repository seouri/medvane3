class CreatePubtypes < ActiveRecord::Migration
  def self.up
    create_table :pubtypes do |t|
      t.string :term
    end
    add_index :pubtypes, :term
  end

  def self.down
    drop_table :pubtypes
  end
end
