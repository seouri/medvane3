class CreateBibliomeSubjects < ActiveRecord::Migration
  def self.up
    create_table :bibliome_subjects do |t|
      t.integer :bibliome_id
      t.integer :subject_id
      t.string :year
      t.integer :articles_count, :default => 0
    end
    add_index :bibliome_subjects, [:bibliome_id, :subject_id, :year]
    add_index :bibliome_subjects, [:bibliome_id, :year, :articles_count], :name => 'index_bibliome_subjects_on_bibliome_id_year_articles_count'
  end

  def self.down
    drop_table :bibliome_subjects
  end
end
