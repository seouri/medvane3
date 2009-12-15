class CreateAuthorships < ActiveRecord::Migration
  def self.up
    create_table :authorships do |t|
      t.integer :article_id
      t.integer :author_id
      t.integer :position
      t.integer :last_position
    end
    add_index :authorships, [:article_id, :position]
    add_index :authorships, :author_id
  end

  def self.down
    drop_table :authorships
  end
end
