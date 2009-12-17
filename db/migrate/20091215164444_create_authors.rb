class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :last_name
      t.string :fore_name
      t.string :initials
      t.string :suffix
    end
    add_index :authors, [:last_name, :fore_name, :suffix], :unique => true
    add_index :authors, [:last_name, :initials]
  end

  def self.down
    remove_index :table_name, :column => [:column_name, :column_name]
    drop_table :authors
  end
end
