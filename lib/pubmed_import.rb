require 'cgi'
require 'net/http'
require 'uri'

class PubmedImport < Struct.new(:query)
  def perform
    webenv, count = esearch(query)
    0.step(count, 10000) do |retstart|    
      efetch = efetch(webenv, retstart)
      efetch.split(/\n\n+/).each do |e|
        m = Bio::MEDLINE.new(e)
        a = Article.new
        a.id                = m.pmid
        a.journal_id        = m.pubmed['JID']
        a.vol               = m.vi
        a.issue             = m.ip
        a.page              = m.pg
        #a.pubdate
        #a.medline_date
        a.title             = m.ti
        a.vernacular_title  = m.pubmed.['TT']
        a.abstract          = m.ab
        a.affiliation       = m.ad
        a.save!
      end
    end
  end
  def perform_old
    pmids = Bio::NCBI::REST.esearch(query, {"retmax" => 100000}, 0)
    efetch = Bio::PubMed.efetch(pmids)
    efetch.each do |e|
      m = Bio::MEDLINE.new(e)
    end
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