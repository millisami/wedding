class SitesController < ApplicationController
    layout 'site'

    before_filter :login_required, :only => [:save_cart, :save_order]
    
    def index
		@categories = Category.find(:all, :order => 'updated_at DESC')
		#@products = Product.find(:all)
	end
	
	def add_to_cart
		@product = Product.find(params[:id])
		quantity = params[:quantity].to_i
		@cart.add_product(@product, quantity)
		respond_to do |format|
            format.html  { redirect_to(:action => 'show_cart') }
            format.js
		end
	end
	
	def remove_from_cart
        product = Product.find(params[:id])
        @cart.remove_product(product)
        flash[:notice] = "Item removed successfully!"
        respond_to do |format|
            format.js
        end
	end
	def remove_from_cart_order_page
        @product = Product.find(params[:id])
        @cart.remove_product(@product)
        flash[:notice] = "Item removed successfully!"
        respond_to do |format|
            format.js
        end
	end

	def update_cart_quantity
        product = Product.find(params[:id])
        @cart.update_quantity(product, params[:quantity])
        flash[:notice] = "Quantity updated successfully!"
        respond_to do |format|
            format.js
        end
	end

	def empty_cart
        @cart.empty_all_items
        flash[:notice] = "Your cart is empty."
	end
	
	def show_cart
        if @cart.items.empty?
            flash[:notice] = "Your cart is empty."
        end
        respond_to do |format|
            format.html {render :layout => false}
            #format.js
        end
	end
	
	def change_currency
        #product = Product.find(params[:id])
        @exchange_currency = params[:exchange_rate]
        @converted_money=CurrencyExchange.currency_exchange(@cart.total_price, "EUR", @exchange_currency)
        session[:exchange_currency] = @cart.exchange_currency = @exchange_currency.to_s

        respond_to do |format|
            format.js
        end
	end

	def save_cart
        respond_to do |format|
            format.html {render :layout => false}
        end
	end

    def tax_delivery_cost
        respond_to do |format|
            format.html {render :layout => false}
        end
    
    end

end
