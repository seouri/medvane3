journals_file = File.join(File.dirname(__FILE__), 'journals.txt')
if File.stat(journals_file).size > 0
  File.foreach(journals_file) do |record|
    j = Journal.new
    j.id, j.title, j.abbr, issn, essn, nlm_id = record.chomp.split("\t")
    j.save! unless Journal.find_by_title_and_abbr(j.title, j.abbr)
  end
end

descriptor_file = File.join(File.dirname(__FILE__), 'desc.2010.txt')
if File.stat(descriptor_file).size > 0
  File.foreach(descriptor_file) do |record|
    s = Subject.new
    s.id, s.term, trees = record.chomp.split("\t")
    s.save!
  end
end

mesh_trees_file = File.join(File.dirname(__FILE__), 'mesh_trees.2010.txt')
if File.stat(mesh_trees_file).size > 0
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