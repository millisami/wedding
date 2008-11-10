# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  expires_session :time => 2.hours, :redirect_to => '/login', :on_expiry => lambda {
    flash[:notice] = "Your session has been expired, and you have been logged out."
  }

  before_filter :find_or_create_cart, :exchange_rate

  helper :all # include all helpers, all the time

  include AuthenticatedSystem
  include HoptoadNotifier::Catcher
  
  # don't show passwords in logs
  filter_parameter_logging 'password'

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
		session[:exchange_currency] = "SEK"
	    end
	    @exchange_rate = ExchangeRate.all
	end
end
