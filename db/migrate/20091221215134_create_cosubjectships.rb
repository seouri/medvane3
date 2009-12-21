class CreateCosubjectships < ActiveRecord::Migration
  def self.up
    create_table :cosubjectships do |t|
      t.integer :subject_id
      t.integer :cosubject_id
      t.string :year
      t.integer :direct
      t.integer :descendant
      t.integer :total
    end
    add_index :cosubjects, [:bibliome_id, :subject_id]
  end

  def self.down
    drop_table :cosubjectships
  end
end
