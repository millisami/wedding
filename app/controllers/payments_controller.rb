class PaymentsController < ApplicationController
  layout 'site'
  include ActiveMerchant::Billing
  def index
    respond_to do |format|
	    format.html
    end
  end

  def confirm
    redirect_to :action => 'index' unless params[:token]
    details_response = gateway.details_for(params[:token])

    if !details_response.success?
      @message = details_response.message
      render :action => 'error'
      return
    end
    @adddress = details_response.address
  end


  def complete
    purchase = gateway.purchase(5000,
      :ip       => request.remote_ip,
      :payer_id => params[:payer_id],
      :token    => params[:token]
    )

    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
      return
    end
  end

  def checkout
    setup_response = gateway.setup_purchase(5000,
      :ip => request.remote_ip,
      :return_url => url_for(:action => 'confirm', :only_path => false),
      :cancel_return_url => url_for(:action => 'index', :only_path => false)
    )
    redirect_to gateway.redirect_url_for(setup_response.token)
  end
  def error
    respond_to do |format|
      format.html
	  
    end
  end

  private #-------------------
  def gateway
    @gateway ||= PaypalExpressGateway.new(
      :login => 'millisami_api1.hotmail.com',
      :password => 'CN3GVE3DT259Q7DK',
      :signature => 'Ai1PaghZh5FmBLCDCTQpwG8jB264A.YuRr1OReXtL71rElj7eJ3FcLDX'
    )
  end

end
