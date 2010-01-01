require 'cgi'
require 'net/http'
require 'uri'

module Medvane::Eutils
  EUTILS_URL  = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/"
  TOOL_NAME   = "my.medvane.org"
  TOOL_EMAIL  = "eutils@medvane.org"

  def esearch(query)
    #return "devmock", 191 if ENV["RAILS_ENV"] == "development"
    server = EUTILS_URL + "esearch.fcgi"
    params = {
      "db"          => "pubmed",
      "term"        => query,
      "tool"        => TOOL_NAME,
      "email"       => TOOL_EMAIL,
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

  def efetch(webenv, retstart = 0, retmax = 5000, rettype = "uilist")
    if ENV["RAILS_ENV"] == "xdevelopment"
      response = IO.read("#{RAILS_ROOT}/test/fixtures/kohane_i.medline")
      medline = response.split(/\n\n+/).map {|e| Bio::MEDLINE.new(e) }
      retmax = medline.index(medline.last) if medline.index(medline.last) < retmax
      return medline[retstart .. retmax]
    end
    server = EUTILS_URL + "efetch.fcgi"
    params = {
      "db"          => "pubmed",
      "tool"        => TOOL_NAME,
      "email"       => TOOL_EMAIL,
      "WebEnv"      => webenv,
      "retmax"      => retmax,
      "rettype"     => rettype,
      "retmode"     => "text",
      "retstart"    => retstart,
      "query_key"   => 1,
    }
    response = Net::HTTP.post_form(URI.parse(server), params)
    medline = []
    unless response.body.blank?
      case rettype
      when "uilist"
        medline = response.body.split(/\n/)
      when "medline"
        medline = response.body.split(/\n\n+/).map {|e| Bio::MEDLINE.new(e) }
      end
    end
    return medline
  end
  module_function :efetch
end