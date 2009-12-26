class CreateBibliomeSubjects < ActiveRecord::Migration
  def self.up
    create_table :bibliome_subjects do |t|
      t.integer :bibliome_id
      t.integer :subject_id
      t.integer :one
      t.integer :five
      t.integer :ten
      t.integer :all
    end
    add_index :bibliome_subjects, :bibliome_id
  end

  def self.down
    drop_table :bibliome_subjects
  end
end
