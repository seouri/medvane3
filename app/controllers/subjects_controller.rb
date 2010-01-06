class SubjectsController < ApplicationController
  # GET /subjects
  # GET /subjects.xml
  def index
    @subjects = @bibliome.subjects.period("all").paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subjects }
    end
  end

  # GET /subjects/1
  # GET /subjects/1.xml
  def show
    @subject = Subject.find(params[:id])
    @journals = JournalSubject.find(:all, :conditions => {:bibliome_id => @bibliome.id, :subject_id => @subject.id, :year => "all"}, :order => "total desc", :limit => 10, :include => :journal)
    @authors = AuthorSubject.find(:all, :conditions => {:bibliome_id => @bibliome.id, :subject_id => @subject.id, :year => "all"}, :order => "total_total desc", :limit => 10, :include => :author)
    @cosubjects = Cosubjectship.find(:all, :conditions => {:bibliome_id => @bibliome.id, :subject_id => @subject.id, :year => "all"}, :order => "direct desc", :limit => 10, :include => :cosubject)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subject }
    end
  end

  # GET /subjects/new
  # GET /subjects/new.xml
  def new
    @subject = Subject.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subject }
    end
  end

  # GET /subjects/1/edit
  def edit
    @subject = Subject.find(params[:id])
  end

  # POST /subjects
  # POST /subjects.xml
  def create
    @subject = Subject.new(params[:subject])

    respond_to do |format|
      if @subject.save
        flash[:notice] = 'Subject was successfully created.'
        format.html { redirect_to(@subject) }
        format.xml  { render :xml => @subject, :status => :created, :location => @subject }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subject.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subjects/1
  # PUT /subjects/1.xml
  def update
    @subject = Subject.find(params[:id])

    respond_to do |format|
      if @subject.update_attributes(params[:subject])
        flash[:notice] = 'Subject was successfully updated.'
        format.html { redirect_to(@subject) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subject.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.xml
  def destroy
    @subject = Subject.find(params[:id])
    @subject.destroy

    respond_to do |format|
      format.html { redirect_to(subjects_url) }
      format.xml  { head :ok }
    end
  end
end
