class CheckoutController < ApplicationController
  def index
    @order = Order.new
    respond_to do |format|
      format.html { render :layout => false }
      
    end
  end

  def place_order
  end

  def thank_you
  end

end
