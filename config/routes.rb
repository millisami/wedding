ActionController::Routing::Routes.draw do |map|
    def map.controller_actions(controller, actions)
	actions.each do |action|
	    self.send("#{action}", "/#{action}", :controller => controller, :action => action)
	end
    end
 
  

  map.resources :orders
  map.resources :product_sets, :has_many => :products
  map.resources :products
  map.resources :categories, :has_many => :product_sets
  

  map.namespace :admin do |admin|
	admin.resources :categories, :has_many => :product_sets
	admin.resources :product_sets, :has_many => :products
	admin.resources :products
	admin.resources :pages
  end
  map.controller_actions 'payments', %w[checkout confirm]
  map.resources :payments
    map.resources :sites, :collection => {:show_cart => :get}, :member => {
	:add_to_cart => :get, 
	:remove_from_cart => :delete,
	:update_cart_quantity => :put,
	:empty_cart => :put, 
	:save_order => :post,
	:show_receipt => :get,
	:change_currency => :put
   }
   
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
