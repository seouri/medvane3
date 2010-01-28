descriptor_file = File.join(File.dirname(__FILE__), 'desc.2010.txt')
if File.stat(descriptor_file).size > 0
  puts "[#{Time.now.to_s}] load Subject"
  File.foreach(descriptor_file) do |record|
    s = Subject.new
    s.id, s.term, trees = record.chomp.split("\t")
    s.save!
  end
end

mesh_trees_file = File.join(File.dirname(__FILE__), 'mesh_trees.2010.txt')
if File.stat(mesh_trees_file).size > 0
  puts "[#{Time.now.to_s}] load MeshTree"
  File.foreach(mesh_trees_file) do |record|
    t = MeshTree.new
    t.id, t.tree_number, t.subject_id, t.parent_id = record.chomp.split("\t")
    t.save!
    if t.tree_number.match(/^V/)
      s = Subject.find(t.subject_id)
      p = Pubtype.find_or_initialize_by_term(s.term)
      p.id = s.id
      p.save! if p.new_record?
    end
  end
end

mesh_ancestors_file = File.join(File.dirname(__FILE__), 'mesh_ancestors.2010.txt')
if File.stat(mesh_ancestors_file).size > 0
  puts "[#{Time.now.to_s}] load MeshAncestor"
  File.foreach(mesh_ancestors_file) do |record|
    t = MeshAncestor.new
    t.subject_id, t.ancestor_id = record.chomp.split("\t")
    t.save!
  end
end
