require 'digest/md5'
class BuildController < ApplicationController
  def pubmed
    @q = params[:q]
    @count = 0
    unless @q.blank?
      @webenv, @count = Medvane::Eutils.esearch(@q)
      if @count > 0
        @medline = Medvane::Eutils.efetch(@webenv, 0, 5, "medline")
        @show_count = @count < 5 ? @count : 5
        @bibliome_name = Digest::MD5.hexdigest(Time.now.to_f.to_s + @q)
      end
    end
  end

  def import
    q = params[:q]
    webenv = params[:w]
    @count = params[:c] || 0
    @bibliome = Bibliome.find_or_initialize_by_name(params[:name])
    if @bibliome.new_record? and q.blank? == false and webenv.blank? == false and @count.to_i > 1
      @bibliome.query = q
      @bibliome.total_articles = @count
      @bibliome.save!
      priority = (50 / Math.log(@count)).to_i
      Delayed::Job.enqueue(PubmedImport.new(@bibliome.id, webenv), priority)
    end
  end

  def upload
    
  end
end
