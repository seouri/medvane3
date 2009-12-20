require 'digest/md5'
class BuildController < ApplicationController
  def pubmed
    @q = params[:q]
    @count = 0
    unless @q.blank?
      webenv, @count = Medvane::Eutils.esearch(@q)
      @medline = Medvane::Eutils.efetch(webenv, 0, 10)
      @show_count = @count < 10 ? @count : 10
      @bibliome_name = Digest::MD5.hexdigest(Time.now.to_f.to_s + @q)
    end
  end

  def import
    q = params[:q]
    @count = params[:c] || 0
    @bibliome = Bibliome.find_or_initialize_by_name(params[:name])
    if @bibliome.new_record? and q.blank? == false and @count.to_i > 1
      @bibliome.query = params[:q]
      @bibliome.save!
      priority = (50 / Math.log(@count)).to_i
      Delayed::Job.enqueue(PubmedImport.new(q, @bibliome.id), priority)
    end
  end

  def upload
    
  end
end
