require 'cgi'
require 'net/http'
require 'uri'
require 'medline'
# 1. get 5000 PMIDs for a given search
# 2. select PMIDs not in Article
# 3. fetch articles in step 2 in MEDLINE format
# 4. repeat 1-3 until all articles are received
class PubmedImport < Struct.new(:bibliome_id, :webenv, :retstart)
  RETMAX = 200
  ONE_YEAR_IN_SECONDS   = 365 * 24 * 60 * 60
  FIVE_YEARS_IN_SECONDS = 5 * ONE_YEAR_IN_SECONDS
  TEN_YEARS_IN_SECONDS  = 10 * ONE_YEAR_IN_SECONDS

  def perform
    bibliome = Bibliome.find(bibliome_id)
    bibliome.started_at ||= Time.now # timestamp only once!
    bibliome.save!
    article_ids = bibliome.article_ids
    medline = Medvane::Eutils.efetch(webenv, retstart, RETMAX, "medline")

    while medline.size == 0 # webenv expired
      webenv, count = Medvane::Eutils.esearch(bibliome.query)
      medline = Medvane::Eutils.efetch(webenv, retstart, RETMAX, "medline")
      if count > bibliome.total_articles
        bibliome.total_articles = count
        bibliome.save!
      end
    end

    medline.each do |m|
      unless article_ids.include?(m.pmid.to_i) || m.pmid.blank? # do this way rather than medline.reject!{...}.each to save memory
        # http://www.nlm.nih.gov/bsd/mms/medlineelements.html
        a = Article.find_or_initialize_by_id(m.pmid)

        periods = periods(m.pubdate)
        journal = Journal.find_or_create_by_abbr_and_title(m.ta, m.ellipsis_jt)
        subjects = m.major_descriptors.map {|d| Subject.find_by_term(d)}
        ancestors = subjects.map {|s| s.ancestors}.flatten.uniq.reject! {|s| subjects.include?(s)}
        pubtypes = m.pt.map {|p| Pubtype.find_or_create_by_term(p.gsub(/JOURNAL ARTICLE/, "Journal Article"))}
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

        periods.each do |year|
          bibliome.increment!("#{year}_articles_count") if ["one", "five", "ten"].include?(year)
          # bibliome_journals
          bj = BibliomeJournal.find_or_initialize_by_bibliome_id_and_year_and_journal_id(bibliome.id, year, journal.id)
          bj.increment!(:articles_count)
      
          authors.each_index do |i|
            author = authors[i]
            position = position_name(i + 1, authors.size)

            #bibliome.author_journals
            aj = AuthorJournal.find_or_initialize_by_bibliome_id_and_author_id_and_journal_id_and_year(bibliome.id, author.id, journal.id, year)
            aj.increment(position)
            aj.increment(:total)
            aj.save!

            #bibliome.coauthorships
            authors.select {|c| c.id != author.id}.each do |coauthor|
              ca = Coauthorship.find_or_initialize_by_bibliome_id_and_author_id_and_coauthor_id_and_year(bibliome.id, author.id, coauthor.id, year)
              ca.increment(position)
              ca.increment(:total)
              ca.save!
            end

            #bibliome.author_subjects
            subjects.each do |subject|
              as = AuthorSubject.find_or_initialize_by_bibliome_id_and_author_id_and_subject_id_and_year(bibliome.id, author.id, subject.id, year)
              ["_direct", "_total"].each do |stype|
                as.increment(position + stype)
                as.increment("total" + stype)
                as.save!
              end
            end
            ## author_subject descendant
            ancestors.try(:each) do |subject|
              as = AuthorSubject.find_or_initialize_by_bibliome_id_and_author_id_and_subject_id_and_year(bibliome.id, author.id, subject.id, year)
              ["_descendant", "_total"].each do |stype|
                as.increment(position + stype)
                as.increment("total" + stype)
                as.save!
              end
            end

            #bibliome.author_pubtypes
            pubtypes.each do |pubtype|
              ap = AuthorPubtype.find_or_initialize_by_bibliome_id_and_author_id_and_pubtype_id_and_year(bibliome.id, author.id, pubtype.id, year)
              ap.increment(position)
              ap.increment(:total)
              ap.save!
            end
        
            # bibliome_authors
            ## TODO: distinguish first/last/middle/total x one/five/ten/all
            ba = BibliomeAuthor.find_or_initialize_by_bibliome_id_and_year_and_author_id(bibliome.id, year, author.id)
            ba.increment!(:articles_count)
          end

          #bibliome.journal_pubtypes
          pubtypes.each do |pubtype|
            jp = JournalPubtype.find_or_initialize_by_bibliome_id_and_journal_id_and_pubtype_id_and_year(bibliome.id, journal.id, pubtype.id, year)
            jp.increment!(:total)
        
            # bibliome_pubtypes
            bp = BibliomePubtype.find_or_initialize_by_bibliome_id_and_year_and_pubtype_id(bibliome.id, year, pubtype.id)
            bp.increment!(:articles_count)
          end

          #bibliome.journal_subject
          subjects.each do |subject|
            js = JournalSubject.find_or_initialize_by_bibliome_id_and_journal_id_and_subject_id_and_year(bibliome.id, journal.id, subject.id, year)
            js.increment(:direct)
            js.increment(:total)
            js.save!
        
            #bibliome.cosubjects
            subjects.reject {|s| s.id == subject.id}.each do |cosubject|
              cs = Cosubjectship.find_or_initialize_by_bibliome_id_and_subject_id_and_cosubject_id_and_year(bibliome.id, subject.id, cosubject.id, year)
              cs.increment(:direct)
              cs.increment(:total)
              cs.save!
            end

            #cosubjectst descendant
            subjects.reject {|s| s.id == subject.id}.map {|s| s.ancestors}.flatten.uniq.reject! {|s| subjects.include?(s) || (subject.id == s.id)}.try(:each) do |cosubject|
              cs = Cosubjectship.find_or_initialize_by_bibliome_id_and_subject_id_and_cosubject_id_and_year(bibliome.id, subject.id, cosubject.id, year)
              cs.increment(:descendant)
              cs.increment(:total)
              cs.save!
            end
        
            # bibliome_subjects
            # TODO: update schema to distinguish direct/descendant
            bs = BibliomeSubject.find_or_initialize_by_bibliome_id_and_year_and_subject_id(bibliome.id, year, subject.id)
            bs.increment!(:articles_count)
          end

          ## journal_subject descendant
          ancestors.try(:each) do |subject|
            js = JournalSubject.find_or_initialize_by_bibliome_id_and_journal_id_and_subject_id_and_year(bibliome.id, journal.id, subject.id, m.year)
            js.increment(:descendant)
            js.increment(:total)
            js.save!
            # bibliome_subjects descendants
            # TODO: update schema to distinguish direct/descendant
            ## one, five, ten
          end
        end

        BibliomeArticle.find_or_create_by_bibliome_id_and_article_id_and_pubdate(bibliome.id, a.id, a.pubdate)
        bibliome.save!
      end
    end

    ["all", "one", "five", "ten"].each do |period|
      ["journals", "authors", "subjects", "pubtypes"].each do |obj| #TODO: genes
        col = "#{period}_#{obj}_count"
        val = bibliome.send(obj).period(period).count
        bibliome.update_attribute(col, val)
      end
    end

    bibliome.all_articles_count = BibliomeArticle.count('id', :conditions => {:bibliome_id => bibliome.id})
    if bibliome.all_articles_count == bibliome.total_articles
      bibliome.built = true
      bibliome.built_at = Time.now
      bibliome.delete_at = 2.weeks.from_now
      bibliome.save!
    end
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

  def periods(pubdate)
    article_age = (Time.now.to_time - pubdate.to_time).round
    article_age = 0 if article_age < 0
    periods = [pubdate[0, 4], "all"]
    periods.push("one")   if article_age <= ONE_YEAR_IN_SECONDS
    periods.push("five")  if article_age <= FIVE_YEARS_IN_SECONDS
    periods.push("ten")   if article_age <= TEN_YEARS_IN_SECONDS
    return periods
  end
end
