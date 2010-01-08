class CreateCosubjectships < ActiveRecord::Migration
  def self.up
    create_table :cosubjectships do |t|
      t.integer :bibliome_id
      t.integer :subject_id
      t.integer :cosubject_id
      t.string :year
      t.integer :direct, :default => 0
      t.integer :descendant, :default => 0
      t.integer :total, :default => 0
    end
    add_index :cosubjectships, [:bibliome_id, :subject_id, :year, :cosubject_id], :name => 'index_cosubjectships_on_bibliome_subject_year_cosubject'
    add_index :cosubjectships, [:bibliome_id, :subject_id, :year, :direct], :name => 'index_cosubjectships_on_bibliome_subject_year_direct'
  end

  def self.down
    drop_table :cosubjectships
  end
end
