class ProductSetsController < ApplicationController
    layout 'site'
	before_filter :find_category

  def index
	@product_sets = @category.product_sets.find(:all)

	@products = Product.find(:all, :conditions => ["product_set_id = ?", @product_sets.first ], :limit => 6)
    respond_to do |format|
      format.html
      # format.js
    end
  end

  private #----------------------
  def find_category
	@category = Category.find(params[:category_id])
  end
end
