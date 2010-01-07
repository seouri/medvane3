class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :last_name
      t.string :fore_name
      t.string :initials
      t.string :suffix
    end
    add_index :authors, [:last_name, :fore_name, :initials, :suffix], :unique => true
    add_index :authors, [:last_name, :initials]
  end

  def self.down
    drop_table :authors
  end
end
