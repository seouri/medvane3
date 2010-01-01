class BibliomesController < ApplicationController
  # GET /bibliomes
  # GET /bibliomes.xml
  def index
    @bibliomes = Bibliome.built.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bibliomes }
    end
  end

  # GET /bibliomes/1
  # GET /bibliomes/1.xml
  def show
    @bibliome = Bibliome.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bibliome }
    end
  end

  # GET /bibliomes/new
  # GET /bibliomes/new.xml
  def new
    @bibliome = Bibliome.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bibliome }
    end
  end

  # GET /bibliomes/1/edit
  def edit
    @bibliome = Bibliome.find(params[:id])
  end

  # POST /bibliomes
  # POST /bibliomes.xml
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

  # PUT /bibliomes/1
  # PUT /bibliomes/1.xml
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

  # DELETE /bibliomes/1
  # DELETE /bibliomes/1.xml
  def destroy
    @bibliome = Bibliome.find(params[:id])
    @bibliome.destroy

    respond_to do |format|
      format.html { redirect_to(bibliomes_url) }
      format.xml  { head :ok }
    end
  end
end
