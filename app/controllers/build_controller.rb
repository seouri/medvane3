class BuildController < ApplicationController
  def pubmed
    @q = params[:q]
    @count = Bio::NCBI::REST.esearch_count(@q, {"db" => "pubmed"})
    pmids = Bio::PubMed.esearch(@q, {"retmax" => 10})
    efetch = Bio::PubMed.efetch(pmids)
    @medline = efetch.map {|e| Bio::MEDLINE.new(e)}
  end
end
