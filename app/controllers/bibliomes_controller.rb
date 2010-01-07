class BibliomesController < ApplicationController
  def index
    @bibliomes = Bibliome.built.paginate(:page => params[:page], :per_page => 10)
    @prefix = "All "
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bibliomes }
    end
  end

  def recent
    @bibliomes = Bibliome.recent.paginate(:page => params[:page], :per_page => 10)
    @prefix = "Recent "
    respond_to do |format|
      format.html { render :action => "index" }
    end
  end

  def popular
    @bibliomes = Bibliome.popular.paginate(:page => params[:page], :per_page => 10)
    @prefix = "Popular "
    respond_to do |format|
      format.html { render :action => "index" }
    end
  end

  def show
    @bibliome = Bibliome.find(params[:id])
    @bibliome.hit!

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bibliome }
    end
  end

  def new
    @q = params[:q]
    @count = 0
    unless @q.blank?
      @webenv, @count = Medvane::Eutils.esearch(@q)
      @bibliomes = Bibliome.find_all_by_query(@q)
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
    count = params[:c] || 0
    @bibliome = Bibliome.find_or_initialize_by_name(params[:name])
    if @bibliome.new_record? and q.blank? == false and webenv.blank? == false and count.to_i > 1
      @bibliome.query = q
      @bibliome.total_articles = count
      @bibliome.save!
      priority = (50 / Math.log(count)).to_i
      0.step(@bibliome.total_articles.to_i, PubmedImport::RETMAX) do |retstart|    
        Delayed::Job.enqueue(PubmedImport.new(@bibliome.id, webenv, retstart), priority)
      end
      redirect_to @bibliome
    else
      redirect_to new_bibliome_path
    end
  end

  def edit
    @bibliome = Bibliome.find(params[:id])
  end

  def create
    @bibliome = Bibliome.new(params[:bibliome])

    respond_to do |format|
      if @bibliome.save
        flash[:notice] = 'Bibliome was successfully created.'
        format.html { redirect_to(@bibliome) }
        format.xml  { render :xml => @bibliome, :status => :created, :location => @bibliome }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bibliome.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @bibliome = Bibliome.find(params[:id])

    respond_to do |format|
      if @bibliome.update_attributes(params[:bibliome])
        flash[:notice] = 'Bibliome was successfully updated.'
        format.html { redirect_to(@bibliome) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bibliome.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @bibliome = Bibliome.find(params[:id])
    @bibliome.destroy

    respond_to do |format|
      format.html { redirect_to(bibliomes_url) }
      format.xml  { head :ok }
    end
  end
end
