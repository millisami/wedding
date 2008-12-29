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

  
  def find_product_set
	@product_set = ProductSet.find(params[:product_set_id])
  end
end
