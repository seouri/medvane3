class CreateJournalSubjects < ActiveRecord::Migration
  def self.up
    create_table :journal_subjects do |t|
      t.integer :bibliome_id
      t.integer :journal_id
      t.integer :subject_id
      t.string :year
      t.integer :direct, :default => 0
      t.integer :descendant, :default => 0
      t.integer :total, :default => 0
    end
    add_index :journal_subjects, [:bibliome_id, :journal_id, :year]
    add_index :journal_subjects, [:bibliome_id, :subject_id, :year]
  end

  def self.down
    drop_table :journal_subjects
  end
end
