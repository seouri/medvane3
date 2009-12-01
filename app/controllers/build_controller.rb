class BuildController < ApplicationController
  def pubmed
    @q = params[:q]
    @count = Bio::NCBI::REST.esearch_count(@q, {"db" => "pubmed"})
    pmids = Bio::PubMed.esearch(@q, {"retmax" => 10})
    efetch = Bio::PubMed.efetch(pmids)
    @medline = efetch.map {|e| Bio::MEDLINE.new(e)}
  end

  def import
    @q = params[:q]
    pmids = Bio::NCBI::REST.esearch(@q, {"retmax" => 100000}, 0)
    efetch = Bio::PubMed.efetch(pmids)    
  end
end
