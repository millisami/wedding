class Admin::ProductSetsController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :check_administrator_role

  # GET /product_sets
  # GET /product_sets.xml
  def index
    @product_sets = ProductSet.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_sets }
    end
  end

  # GET /product_sets/1
  # GET /product_sets/1.xml
  def show
    @product_set = ProductSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_set }
    end
  end

  # GET /product_sets/new
  # GET /product_sets/new.xml
  def new
	@product_set = ProductSet.new
	@categories = Category.find(:all)
    
	#logger.debug_variables(binding)
    
	respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_set }
    end
  end

  # GET /product_sets/1/edit
  def edit
	@categories = Category.find(:all)
    @product_set = ProductSet.find(params[:id])
  end

  # POST /product_sets
  # POST /product_sets.xml
  def create
		
    @product_set = ProductSet.new(params[:product_set])
	#@product_set.category_id = params[:category][:category_id]
	#logger.debug "After Hello world"
    respond_to do |format|
      if @product_set.save
        flash[:notice] = 'ProductSet was successfully created.'
        format.html { redirect_to(admin_product_sets_url) }
        format.xml  { render :xml => @product_set, :status => :created, :location => @product_set }
      else
		format.html { render :action => "new" }
        format.xml  { render :xml => @product_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /product_sets/1
  # PUT /product_sets/1.xml
  def update
    @product_set = ProductSet.find(params[:id])
	#category = Categories.find(params[:category_id])
	#@product_set.category = category
	
    respond_to do |format|
      if @product_set.update_attributes(params[:product_set])
        flash[:notice] = 'ProductSet was successfully updated.'
        format.html { redirect_to(admin_product_sets_url) }
        format.xml  { head :ok }
      else
		@categories = Category.find(:all)

        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_sets/1
  # DELETE /product_sets/1.xml
  def destroy
    @product_set = ProductSet.find(params[:id])
    @product_set.destroy

    respond_to do |format|
      format.html { redirect_to(admin_product_sets_url) }
      format.xml  { head :ok }
    end
  end

  def sort
      @products = Product.find_all_by_product_set_id(params[:id], :order => "position")
      #@products = Product.all(:conditions => { :product_set_id => params[:id] }, :order => "position ASC")
       respond_to do |format|
      format.html
    end
  end

  def save_position
    params[:products].each_with_index do |id, index|
        Product.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
end

end
