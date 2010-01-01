require 'cgi'
require 'net/http'
require 'uri'
require 'medline'
# 1. get 5000 PMIDs for a given search
# 2. select PMIDs not in Article
# 3. fetch articles in step 2 in MEDLINE format
# 4. repeat 1-3 until all articles are received
class PubmedImport < Struct.new(:bibliome_id, :webenv, :count)
  RETMAX = 5000

  def perform
    bibliome = Bibliome.find(bibliome_id)
    bibliome.started_at = Time.now
    bibliome.save!
    #webenv, count = Medvane::Eutils.esearch(query)
    0.step(count.to_i, RETMAX) do |retstart|    
      medline = Medvane::Eutils.efetch(webenv, retstart, RETMAX, "medline")
      medline.each do |m|
        # http://www.nlm.nih.gov/bsd/mms/medlineelements.html
        a = Article.find_or_initialize_by_id(m.pmid)

        journal = Journal.find_or_create_by_abbr_and_title(m.ta, m.jt)
        subjects = m.major_descriptors.map {|d| Subject.find_by_term(d)}
        ancestors = subjects.map {|s| s.ancestors}.flatten.uniq.reject! {|s| subjects.include?(s)}
        pubtypes = m.pt.map {|p| Pubtype.find_by_term(p)}
        authors = m.authors.map {|u| Author.find_or_create_by_last_name_and_fore_name_and_initials_and_suffix(u['last_name'], u['fore_name'], u['initials'], u['suffix'])}
        genes = []
        
        # article
        if a.new_record?
          a.journal      = journal
          a.pubdate      = m.pubdate
          a.title        = m.ti
          a.affiliation  = m.ad
          a.source       = m.source
          a.save!

          subjects.each do |s|
            a.subjects<<(s)
          end

          pubtypes.each do |p|
            a.pubtypes<<(p)
          end

          last_position = authors.size
          authors.each_index do |i|
            position = i + 1
            authors[i].authorships.create!(
              :article => a,
              :position => position,
              :last_position => last_position
            )
          end
          a.save!
        end

        # bibliome_journals
        bj = BibliomeJournal.find_or_create_by_bibliome_id_and_journal_id(bibliome.id, journal.id)
        bj.increment!(:all)
        ## one, five, ten
        
        authors.each_index do |i|
          author = authors[i]
          position = position_name(i + 1, authors.size)

          #bibliome.author_journals
          aj = AuthorJournal.find_or_create_by_bibliome_id_and_author_id_and_journal_id_and_year(bibliome.id, author.id, journal.id, m.year)
          aj.increment!(position)
          aj.increment!(:total)

          #bibliome.coauthorships
          authors.select {|c| c.id != i}.each do |coauthor|
            ca = Coauthorship.find_or_create_by_bibliome_id_and_author_id_and_coauthor_id_and_year(bibliome.id, author.id, coauthor.id, m.year)
            ca.increment!(position)
            ca.increment!(:total)
          end

          #bibliome.author_subjects
          subjects.each do |subject|
            as = AuthorSubject.find_or_create_by_bibliome_id_and_author_id_and_subject_id_and_year(bibliome.id, author.id, subject.id, m.year)
            ["_direct", "_total"].each do |stype|
              as.increment!(position + stype)
              as.increment!("total" + stype)
            end
          end
          ## author_subject descendant
          ancestors.try(:each) do |subject|
            as = AuthorSubject.find_or_create_by_bibliome_id_and_author_id_and_subject_id_and_year(bibliome.id, author.id, subject.id, m.year)
            ["_descendant", "_total"].each do |stype|
              as.increment!(position + stype)
              as.increment!("total" + stype)
            end
          end

          #bibliome.author_pubtypes
          pubtypes.each do |pubtype|
            ap = AuthorPubtype.find_or_create_by_bibliome_id_and_author_id_and_pubtype_id_and_year(bibliome.id, author.id, pubtype.id, m.year)
            ap.increment!(position)
            ap.increment!(:total)
          end
          
          # bibliome_authors
          ba = BibliomeAuthor.find_or_create_by_bibliome_id_and_author_id(bibliome.id, author.id)
          ba.increment!(:all)
          ## one, five, ten
        end

        #bibliome.journal_pubtypes
        pubtypes.each do |pubtype|
          jp = JournalPubtype.find_or_create_by_bibliome_id_and_journal_id_and_pubtype_id_and_year(bibliome.id, journal.id, pubtype.id, m.year)
          jp.increment!(:articles)
          
          # bibliome_pubtypes
          bp = BibliomePubtype.find_or_create_by_bibliome_id_and_pubtype_id(bibliome.id, pubtype.id)
          bp.increment!(:all)
          ## one, five, ten
          
        end

        #bibliome.journal_subject
        subjects.each do |subject|
          js = JournalSubject.find_or_create_by_bibliome_id_and_journal_id_and_subject_id_and_year(bibliome.id, journal.id, subject.id, m.year)
          js.increment!(:direct)
          js.increment!(:total)
          
          #bibliome.cosubjects
          subjects.reject {|s| s.id == subject.id}.each do |cosubject|
            cs = Cosubjectship.find_or_create_by_bibliome_id_and_subject_id_and_cosubject_id_and_year(bibliome.id, subject.id, cosubject.id, m.year)
            cs.increment!(:direct)
            cs.increment!(:total)
          end

          #cosubjectst descendant
          subjects.reject {|s| s.id == subject.id}.map {|s| s.ancestors}.flatten.uniq.reject! {|s| subjects.include?(s) || (subject.id == s.id)}.try(:each) do |cosubject|
            cs = Cosubjectship.find_or_create_by_bibliome_id_and_subject_id_and_cosubject_id_and_year(bibliome.id, subject.id, cosubject.id, m.year)
            cs.increment!(:descendant)
            cs.increment!(:total)
          end
          
          # bibliome_subjects
          # TODO: update schema to distinguish direct/descendant
          bs = BibliomeSubject.find_or_create_by_bibliome_id_and_subject_id(bibliome.id, subject.id)
          bs.increment!(:all)
          ## one, five, ten
          
        end

        ## journal_subject descendant
        ancestors.try(:each) do |subject|
          js = JournalSubject.find_or_create_by_bibliome_id_and_journal_id_and_subject_id_and_year(bibliome.id, journal.id, subject.id, m.year)
          js.increment!(:descendant)
          js.increment!(:total)
          # bibliome_subjects descendants
          # TODO: update schema to distinguish direct/descendant
          ## one, five, ten
        end
 
        bibliome.articles<<(a)
        bibliome.save!
      end
    end

    bibliome.built = true
    bibliome.built_at = Time.now
    bibliome.delete_at = 2.weeks.from_now
    bibliome.save!
  end
  
  def position_name(position, last_position)
    if position == 1
      return "first"
    elsif position > 1 && position == last_position
      return "last"
    else
      return "middle"
    end
  end
end
