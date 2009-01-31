ActionController::Routing::Routes.draw do |map|

  def map.controller_actions(controller, actions)
    actions.each do |action|
	    self.send("#{action}", "/#{action}", :controller => controller, :action => action)
    end
  end
 
  map.namespace :admin do |admin|
    admin.resources :categories, :has_many => :product_sets
    admin.resources :product_sets, :has_many => :products
    admin.resources :products
    admin.resources :pages
    admin.resources :shipping_rates
  end
  map.resources :orders
  map.resources :product_sets, :has_many => :products
  map.resources :products
  map.resources :categories, :has_many => :product_sets

  map.resources :shipping_rates
  map.resources :payment_notifications

  #map.controller_actions 'payments', %w[checkout confirm]
  map.controller_actions 'sites', %w[tax_delivery_cost]
  map.resources :payments
  map.checkout '/checkout', :controller => 'checkout', :action => 'index'

  map.resources :sites, :member => {
    :add_to_cart => :post,
    :remove_from_cart => :delete,
    :update_cart_quantity => :put,
    :show_receipt => :get,
    :change_currency => :put,
  }
  map.save_cart '/save_cart', :controller => 'sites', :action => 'save_cart'
  map.show_cart '/show_cart', :controller => 'sites', :action => 'show_cart'
  map.save_order '/save_order', :controller => 'sites', :action => 'save_order'

  map.empty_cart '/empty_cart', :controller => 'sites', :action => 'empty_cart'

  #map.checkout '/checkout', :controller => 'payments', :action => 'checkout'
    
  #map.root :controller => "pages", :action => "show_position", :id => 1
  map.root :controller => "sites", :action => "index"
  #map.checkout '/checkout', :controller => 'sites', :action => 'checkout'
  map.admin '/admin', :controller => 'admin/product_sets', :action => 'index'
  map.signup '/signup', :controller => 'users',    :action => 'new'
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.activate '/activate/:id', :controller => 'accounts', :action => 'show'
  map.forgot_password '/forgot_password',    :controller => 'passwords', :action => 'new'
  map.reset_password  '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.change_password '/change_password',    :controller => 'accounts',  :action => 'edit'
  #  map.compose '/compose', :controller => 'messages', :action => 'new'
  #  map.send    '/send',    :controller => 'messages', :action => 'create'

  # See how all your routes lay out with "rake routes"
  map.resources :pages, :member => { 
    :show_position => :get, 
    :move_higher => :put, 
    :move_lower => :put 
  }
  
  map.resources :users, :member => { :enable => :put } do |user|
    user.resource :account
    user.resources :roles
  end
  
  map.resource :session
  map.resource :password
  map.resource :message
  
end
