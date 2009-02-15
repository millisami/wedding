class ShippingRatesController < ApplicationController
  def show
    @shipping_rate = ShippingRate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shipping_rate }
    end
  end
end
