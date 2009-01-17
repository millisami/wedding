class OrdersController < ApplicationController
  layout 'site'
  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @order = Order.new
   #@customer = Customer.new
    respond_to do |format|
      format.html #{ render :layout => false }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    @order.customer_ip = request.remote_ip
    #populate_order
<<<<<<< Updated upstream:app/controllers/orders_controller.rb
     @order.line_items << @cart.items
    respond_to do |format|
      if @order.save
#        if @order.process
#          flash[:notice] = 'Your order has been submitted, and will be processed immediately.'
#          session[:order_id] = @order.id
#          # Empty the cart
#          @cart.empty_all_items
#          format.html { redirect_to :action => 'thank_you' }
#        else
#          flash[:notice] = "Error while placing order. '#{@order.error_message}'"
#          format.html { render :action => 'index' }
#        end
        format.js do
          #render :action => 'index'
          render :update do |page|
            flash[:notice] = "Thank you for your order."
          page.reload_flash
         end
=======
    debugger
    @order.line_items << @cart.items
    debugger
    respond_to do |format|
      format. js {
        if @order.save

          flash[:notice] = 'Your order has been submitted, and will be processed immediately.'
          session[:order_id] = @order.id
          # Empty the cart
          @cart.empty_all_items

        else
          render :json => {:object => "order", :success => false, :errors => @order.errors}
          debugger
        end
        
      }
      format.html {
        if @order.save
          flash[:notice] = 'Your order has been submitted'
          session[:order_id] = @order.id
          @cart.empty_all_items
          render :action => 'new'
        else
          flash[:notice] = 'Some error occured'
          redirect_to new_order_path
>>>>>>> Stashed changes:app/controllers/orders_controller.rb
        end
      else
        format.js do
          #render :action => 'index'
          render :update do |page|
            flash[:notice] = "Error checking out. Re-order again!!"
          page.reload_flash
         end

        end
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        flash[:notice] = 'Order was successfully updated.'
        format.html { redirect_to(@order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  private #=============
  def populate_order
    @order.line_items << @cart.items
  end
end
