require 'cgi'
require 'net/http'
require 'uri'

class PubmedImport < Struct.new(:query, :bibliome_id)
  def perform
    bibliome = Bibliome.find(bibliome_id)
    webenv, count = esearch(query)
    #bibliome.articles_count = count
    bibliome.delete_at = 2.weeks.from_now
    bibliome.save!
    0.step(count, 10000) do |retstart|    
      efetch = efetch(webenv, retstart)
      efetch.split(/\n\n+/).each do |e|
        m = Bio::MEDLINE.new(e)
        journal = Journal.find_or_initialize_by_abbr(m.ta)
        if journal.new_record?
          journal.title = m.pubmed['JT']
          journal.save!
        end
        a = Article.find_or_initialize_by_id(m.pmid)
        a.journal           = journal
        a.vol               = m.vi
        a.issue             = m.ip
        a.page              = m.pg
        #a.pubdate
        a.medline_date      = m.dp
        a.title             = m.ti
        #a.vernacular_title  = m.pubmed['TT']
        #a.abstract          = m.ab
        a.affiliation       = m.ad
        a.source            = m.source
        a.bibliomes<<(bibliome)
        a.save!
      end
    end
    bibliome.built = true
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