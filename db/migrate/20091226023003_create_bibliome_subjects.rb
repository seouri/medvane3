class CreateBibliomeSubjects < ActiveRecord::Migration
  def self.up
    create_table :bibliome_subjects do |t|
      t.integer :bibliome_id
      t.integer :subject_id
      t.string :year
      t.integer :articles_count, :default => 0
    end
    add_index :bibliome_subjects, [:bibliome_id, :articles_count]
    add_index :bibliome_subjects, [:bibliome_id, :year, :subject_id]
  end

  def self.down
    drop_table :bibliome_subjects
  end
end
