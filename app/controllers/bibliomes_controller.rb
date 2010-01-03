class BibliomesController < ApplicationController
  def index
    @bibliomes = Bibliome.built.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bibliomes }
    end
  end

  def recent
    @bibliomes = Bibliome.recent.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html { render :action => "index" }
    end
  end

  def popular
    @bibliomes = Bibliome.popular.paginate(:page => params[:page], :per_page => 10)
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
    @bibliome = Bibliome.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bibliome }
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
