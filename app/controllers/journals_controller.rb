class JournalsController < ApplicationController
  # GET /journals
  # GET /journals.xml
  def index
    @journals = @bibliome.journals.period(@period).paginate(:page => params[:page], :per_page => 10, :total_entries => @bibliome.send("#{@period}_journals_count"))

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @journals }
    end
  end

  # GET /journals/1
  # GET /journals/1.xml
  def show
    @journal = Journal.find(params[:id])
    @authors = AuthorJournal.find(:all, :conditions => {:bibliome_id => @bibliome.id, :journal_id => @journal.id, :year => @period}, :order => "total desc", :limit => 10, :include => [:author, :bibliome])
    @subjects = JournalSubject.find(:all, :conditions => {:bibliome_id => @bibliome.id, :journal_id => @journal.id, :year => @period}, :order => "direct desc", :limit => 10, :include => [:subject, :bibliome])
    @pubtypes = JournalPubtype.find(:all, :conditions => {:bibliome_id => @bibliome.id, :journal_id => @journal.id, :year => @period}, :order => "total desc", :limit => 10, :include => [:pubtype, :bibliome])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @journal }
    end
  end

  # GET /journals/new
  # GET /journals/new.xml
  def new
    @journal = Journal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @journal }
    end
  end

  # GET /journals/1/edit
  def edit
    @journal = Journal.find(params[:id])
  end

  # POST /journals
  # POST /journals.xml
  def create
    @journal = Journal.new(params[:journal])

    respond_to do |format|
      if @journal.save
        flash[:notice] = 'Journal was successfully created.'
        format.html { redirect_to(@journal) }
        format.xml  { render :xml => @journal, :status => :created, :location => @journal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /journals/1
  # PUT /journals/1.xml
  def update
    @journal = Journal.find(params[:id])

    respond_to do |format|
      if @journal.update_attributes(params[:journal])
        flash[:notice] = 'Journal was successfully updated.'
        format.html { redirect_to(@journal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.xml
  def destroy
    @journal = Journal.find(params[:id])
    @journal.destroy

    respond_to do |format|
      format.html { redirect_to(journals_url) }
      format.xml  { head :ok }
    end
  end
end
