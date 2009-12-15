require 'cgi'
require 'net/http'
require 'uri'

class PubmedImport < Struct.new(:query, :bibliome_id)
  def perform
    bibliome = Bibliome.find(bibliome_id)
    webenv, count = esearch(query)
    bibliome.delete_at = 2.weeks.from_now
    bibliome.save!
    0.step(count, 5000) do |retstart|    
      efetch = efetch(webenv, retstart)
      efetch.split(/\n\n+/).each do |e|
        # http://www.nlm.nih.gov/bsd/mms/medlineelements.html
        m = Bio::MEDLINE.new(e)
        journal = Journal.find_or_initialize_by_abbr(m.ta)
        if journal.new_record?
          journal.title = m.jt
          journal.save!
        end

        a = Article.find_or_initialize_by_id(m.pmid)
        if a.new_record?
          a.journal      = journal
          a.vol          = m.vi
          a.issue        = m.ip
          a.page         = m.pg
          #a.pubdate
          a.medline_date = m.dp
          a.title        = m.ti
          a.affiliation  = m.ad
          a.source       = m.source
        end
        a.bibliomes<<(bibliome)
        a.save!
        
        last_position = m.authors.size
        m.authors.each do |ma|
          author = Author.find_or_initialize_by_last_name_and_fore_name(ma["last_name"], ma["fore_name"])
          if author.new_record?
            author.initials = ma["initials"]
            author.suffix = ma["suffix"]
            author.save!
            position = m.authors.index(ma) + 1
            author.authorships.create!(:article => a, :position => position, :last_position => last_position)          end

        end
      end
    end
    bibliome.built = true
    bibliome.built_at = Time.now
    bibliome.save!
  end

  def esearch(query)
    server = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
    params = {
      "db"          => "pubmed",
      "term"        => query,
      "tool"        => "medvane.org",
      "retmax"      => 0,
      "usehistory"  => "y",
    }
    response = Net::HTTP.post_form(URI.parse(server), params)
    result = response.body
    count = result.scan(/<Count>(.*?)<\/Count>/m).flatten.first.to_i
    webenv = result.scan(/<WebEnv>(.*?)<\/WebEnv>/m).flatten.first.to_s
    return webenv, count
  end
  
  def efetch(webenv, retstart)
    server = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
    params = {
      "db"          => "pubmed",
      "tool"        => "medvane.org",
      "WebEnv"      => webenv,
      "retmax"      => 10000,
      "rettype"     => "medline",
      "retmode"     => "text",
      "retstart"    => retstart,
      "query_key"   => 1,
    }
    response = Net::HTTP.post_form(URI.parse(server), params)
    return response.body
  end
end