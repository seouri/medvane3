require 'cgi'
require 'net/http'
require 'uri'

class PubmedImport < Struct.new(:query, :bibliome_id)
  def perform
    bibliome = Bibliome.find(bibliome_id)
    webenv, count = Medvane::Eutils.esearch(query)
    0.step(count, 5000) do |retstart|    
      efetch = Medvane::Eutils.efetch(webenv, retstart)
      efetch.each do |m|
        # http://www.nlm.nih.gov/bsd/mms/medlineelements.html
        a = Article.find_or_initialize_by_id(m.pmid)

        journal = Journal.find_or_create_by_abbr_and_title(m.ta, m.jt)
        subjects = m.major_descriptors.map {|d| Subject.find_by_term(d)}
        pubtypes = m.pt.map {|p| Pubtype.find_by_term(p)}
        authors = m.authors.map {|u| Author.find_or_create_by_last_name_and_fore_name_and_initials_and_suffix(u['last_name'], u['fore_name'], u['initials'], u['suffix'])}
        genes = []
        
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
        end

        a.bibliomes<<(bibliome)
        a.save!
      end
    end
    bibliome.built = true
    bibliome.built_at = Time.now
    bibliome.delete_at = 2.weeks.from_now
    bibliome.save!
  end
end