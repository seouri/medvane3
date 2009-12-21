class CreateJournalSubjects < ActiveRecord::Migration
  def self.up
    create_table :journal_subjects do |t|
      t.integer :bibliome_id
      t.integer :journal_id
      t.integer :subject_id
      t.string :year
      t.integer :direct
      t.integer :descendant
      t.integer :total
    end
    add_index :journal_subjects, [:bibliome_id, :journal_id]
    add_index :journal_subjects, [:bibliome_id, :subject_id]
  end

  def self.down
    drop_table :journal_subjects
  end
end
