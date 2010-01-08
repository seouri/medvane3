class CreateAuthorSubjects < ActiveRecord::Migration
  def self.up
    create_table :author_subjects do |t|
      t.integer :bibliome_id
      t.integer :author_id
      t.integer :subject_id
      t.string :year
      t.integer :first_direct, :default => 0
      t.integer :first_descendant, :default => 0
      t.integer :first_total, :default => 0
      t.integer :last_direct, :default => 0
      t.integer :last_descendant, :default => 0
      t.integer :last_total, :default => 0
      t.integer :middle_direct, :default => 0
      t.integer :middle_descendant, :default => 0
      t.integer :middle_total, :default => 0
      t.integer :total_direct, :default => 0
      t.integer :total_descendant, :default => 0
      t.integer :total_total, :default => 0
    end
    add_index :author_subjects, [:bibliome_id, :author_id, :year, :subject_id], :name => 'index_author_subjects_on_bibliome_id_author_id_year_subject_id'
    add_index :author_subjects, [:bibliome_id, :subject_id, :year, :total_direct], :name => 'index_author_subjects_on_bibliome_subject_year_total_direct'
    add_index :author_subjects, [:bibliome_id, :author_id, :year, :total_direct], :name => 'index_author_subjects_on_bibliome_author_year_total_direct'
  end

  def self.down
    drop_table :author_subjects
  end
end
