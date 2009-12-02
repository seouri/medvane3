class BuildController < ApplicationController
  def pubmed
    @q = params[:q]
    @count = Bio::NCBI::REST.esearch_count(@q, {"db" => "pubmed"})
    @show_count = @count < 10 ? @count : 10
    pmids = Bio::PubMed.esearch(@q, {"retmax" => 10})
    efetch = Bio::PubMed.efetch(pmids)
    @medline = efetch.map {|e| Bio::MEDLINE.new(e)}
  end

  def import
    Delayed::Job.enqueue(PubmedImport.new(params[:q]))
  end

  def upload
    
  end
end
