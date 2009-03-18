# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  before_filter :find_or_create_cart, :exchange_rate
  
  after_filter :discard_flash_if_xhr

  helper :all # include all helpers, all the time

  include AuthenticatedSystem
  include HoptoadNotifier::Catcher
  
  # don't show passwords in logs
  filter_parameter_logging 'password'
  filter_parameter_logging :card_number, :card_verification_value, :form1

  #include FaceboxRender

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  :secret => 'afe76908822b45fd48062836e82f84bfghfjfyd'

  protected
  def get_pages
    @pages = Page.find(:all, :order => :position)
  end

	def find_or_create_cart
		@cart = session[:cart] ||= Cart.new
	end

	def exchange_rate
    if session[:exchange_currency].nil?
      session[:exchange_currency] = "EUR"
    end
    @exchange_rate = ExchangeRate.all(:conditions => { :currency => ["EUR", "SEK", "USD", "GBP"]})
	end

  def discard_flash_if_xhr
    flash.discard if request.xhr?
  end

end
