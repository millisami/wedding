class ProductsController < ApplicationController
 before_filter :find_product_set

 # GET /products
  # GET /products.xml
  def index
    @products = @product_set.products.all

    respond_to do |format|
      format.html  { render :partial => "list_products" }
      format.xml  { render :xml => @products }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end
  
  def find_product_set
	@product_set = ProductSet.find(params[:product_set_id])
  end
end
