class PubtypesController < ApplicationController
  # GET /pubtypes
  # GET /pubtypes.xml
  def index
    @pubtypes = @bibliome.pubtypes.period(@period).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pubtypes }
    end
  end

  # GET /pubtypes/1
  # GET /pubtypes/1.xml
  def show
    @pubtype = Pubtype.find(params[:id])
    @journals = JournalPubtype.find(:all, :conditions => {:bibliome_id => @bibliome.id, :pubtype_id => @pubtype.id, :year => @period}, :order => "total desc", :limit => 10, :include => [:journal, :bibliome])    
    @authors = AuthorPubtype.find(:all, :conditions => {:bibliome_id => @bibliome.id, :pubtype_id => @pubtype.id, :year => @period}, :order => "total desc", :limit => 10, :include => [:author, :bibliome])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pubtype }
    end
  end

  # GET /pubtypes/new
  # GET /pubtypes/new.xml
  def new
    @pubtype = Pubtype.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pubtype }
    end
  end

  # GET /pubtypes/1/edit
  def edit
    @pubtype = Pubtype.find(params[:id])
  end

  # POST /pubtypes
  # POST /pubtypes.xml
  def create
    @pubtype = Pubtype.new(params[:pubtype])

    respond_to do |format|
      if @pubtype.save
        flash[:notice] = 'Pubtype was successfully created.'
        format.html { redirect_to(@pubtype) }
        format.xml  { render :xml => @pubtype, :status => :created, :location => @pubtype }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pubtype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pubtypes/1
  # PUT /pubtypes/1.xml
  def update
    @pubtype = Pubtype.find(params[:id])

    respond_to do |format|
      if @pubtype.update_attributes(params[:pubtype])
        flash[:notice] = 'Pubtype was successfully updated.'
        format.html { redirect_to(@pubtype) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pubtype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pubtypes/1
  # DELETE /pubtypes/1.xml
  def destroy
    @pubtype = Pubtype.find(params[:id])
    @pubtype.destroy

    respond_to do |format|
      format.html { redirect_to(pubtypes_url) }
      format.xml  { head :ok }
    end
  end
end
