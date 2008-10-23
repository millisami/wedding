class PagesController < ApplicationController
  layout 'admin'
  before_filter :check_administrator_role, :except => [ :index, :show, :show_position ]

  # GET /pages
  # GET /pages.xml
  def index
#    @pages = Page.find(:all)
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
        format.html { redirect_to([admin, @page]) }
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
        format.html { redirect_to([admin, @page]) }
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
    respond_to do |format|
      format.html { redirect_to(admin_pages_path) }
      format.xml  { head :ok }
    end
  end

  def move_lower
    @page = Page.find(params[:id])
    @page.move_lower
    redirect_to admin_pages_path
  end

  def move_higher
    @page = Page.find(params[:id])
    @page.move_higher
    redirect_to admin_pages_path
  end

  def show_position
    @page = Page.find_by_position(params[:id])
    # the find_by_* method do not error when nothing is found so don't need rescuing
    unless @page
      @page = Page.new
      @page.title = "No page exists with position=#{params[:id]}"
      @page.body  = "No page exists yet with position=#{params[:id]}<br/><br/>"+
          "Your administrator should login and do this unless you entered the position manually."
    end
    respond_to do |format|
      format.html { render :action => 'show' }
      format.xml  { render :action => 'show', :xml => @page }
    end
  end
end
