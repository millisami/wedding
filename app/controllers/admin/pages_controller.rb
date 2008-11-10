class Admin::PagesController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :check_administrator_role

  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    begin
      @page = Page.find(params[:id])
    rescue
      @page = Page.new
      @page.id    = 1
      @page.position = 1
      @page.title = "No page exists with id=#{params[:id]}"
      @page.body  = "No page exists with id=#{params[:id]}<br/><br/>"+
          "Your administrator should login and do this unless you entered the id manually."
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])
    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(admin_pages_url) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])
    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(admin_pages_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    flash[:notice] = 'Page deleted successfully'
    respond_to do |format|
      format.html { redirect_to(admin_pages_url) }
      format.xml  { head :ok }
    end
  end
end