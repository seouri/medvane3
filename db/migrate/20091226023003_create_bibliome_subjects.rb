class CreateBibliomeSubjects < ActiveRecord::Migration
  def self.up
    create_table :bibliome_subjects do |t|
      t.integer :bibliome_id
      t.integer :subject_id
      t.integer :one, :default => 0
      t.integer :five, :default => 0
      t.integer :ten, :default => 0
      t.integer :all, :default => 0
    end
    add_index :bibliome_subjects, [:bibliome_id, :one]
    add_index :bibliome_subjects, [:bibliome_id, :five]
    add_index :bibliome_subjects, [:bibliome_id, :ten]
    add_index :bibliome_subjects, [:bibliome_id, :all]
  end

  def self.down
    drop_table :bibliome_subjects
  end
end
