class CreateMeshAncestors < ActiveRecord::Migration
  def self.up
    create_table :mesh_ancestors do |t|
      t.integer :subject_id
      t.integer :ancestor_id
    end
    add_index :mesh_ancestors, :subject_id
  end

  def self.down
    drop_table :mesh_ancestors
  end
end
