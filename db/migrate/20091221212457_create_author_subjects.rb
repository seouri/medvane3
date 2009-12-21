class CreateAuthorSubjects < ActiveRecord::Migration
  def self.up
    create_table :author_subjects do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.integer :subject_id
      t.string :year
      t.integer :first_direct
      t.integer :first_descendant
      t.integer :first_total
      t.integer :last_direct
      t.integer :last_descendant
      t.integer :last_total
      t.integer :middle_direct
      t.integer :middle_descendant
      t.integer :middle_total
      t.integer :total_direct
      t.integer :total_descendant
      t.integer :total_total
    end
    add_index :author_subjects, [:bibliome_id, :author_id]
    add_index :author_subjects, [:bibliome_id, :subject_id]
  end

  def self.down
    drop_table :author_subjects
  end
end
