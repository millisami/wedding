class ProductSetsController < ApplicationController
	before_filter :find_category

  def index
	@product_sets = @category.product_sets.find(:all)
	@products = Product.find(:all, :conditions => ["product_set_id = ?", 5]) #@product_sets[0].id])
    respond_to do |format|
      format.html  { render :layout => false }# index.html.erb
      # format.js
    end
  end
  
    def show
    @product_set = ProductSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_set }
	  format.js
    end
  end
  
  private #----------------------
  def find_category
	@category = Category.find(params[:category_id])
  end
end
