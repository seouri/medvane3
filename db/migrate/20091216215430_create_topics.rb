class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer :article_id
      t.integer :subject_id
    end
  end

  def self.down
    drop_table :topics
  end
end
