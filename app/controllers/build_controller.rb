require 'digest/md5'
class BuildController < ApplicationController
  def pubmed
    @q = params[:q]
    @count = 0
    unless @q.blank?
      @count = Bio::NCBI::REST.esearch_count(@q, {"db" => "pubmed"})
      @show_count = @count < 10 ? @count : 10
      pmids = Bio::PubMed.esearch(@q, {"retmax" => 10})
      efetch = Bio::PubMed.efetch(pmids)
      @medline = efetch.map {|e| Bio::MEDLINE.new(e)}
      @bibliome_name = Digest::MD5.hexdigest(Time.now.to_f.to_s + @q)
    end
  end

  def import
    q = params[:q]
    @bibliome = Bibliome.find_or_initialize_by_name(params[:name])
    if @bibliome.new_record? and q.blank? == false
      @bibliome.query = params[:q]
      @bibliome.save!
      Delayed::Job.enqueue(PubmedImport.new(q, @bibliome.id))
    end
  end

  def upload
    
  end
end
