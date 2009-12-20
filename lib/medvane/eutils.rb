require 'cgi'
require 'net/http'
require 'uri'

module Medvane::Eutils
  EUTILS_URL = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/"
  def esearch(query)
    server = EUTILS_URL + "esearch.fcgi"
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
  module_function :esearch

  def efetch(webenv, retstart, retmax = 5000)
    server = EUTILS_URL + "efetch.fcgi"
    params = {
      "db"          => "pubmed",
      "tool"        => "medvane.org",
      "WebEnv"      => webenv,
      "retmax"      => retmax,
      "rettype"     => "medline",
      "retmode"     => "text",
      "retstart"    => retstart,
      "query_key"   => 1,
    }
    response = Net::HTTP.post_form(URI.parse(server), params)
    return response.body.split(/\n\n+/).map {|e| Bio::MEDLINE.new(e) }
  end
  module_function :efetch
end