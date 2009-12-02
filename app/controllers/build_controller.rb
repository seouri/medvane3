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
    end
  end

  def import
    q = params[:q]
    unless q.blank?
      @name = params[:bibliome_name].blank? ? Digest::MD5.hexdigest(Time.now.to_f.to_s + q) : params[:bibliome_name]
      bibliome = Bibliome.find_or_initialize_by_name(@name)
      bibliome.query = params[:q]
      bibliome.save!
      Delayed::Job.enqueue(PubmedImport.new(params[:q], bibliome.id))
    end
  end

  def upload
    
  end
end
