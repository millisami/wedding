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

  def create
    @order = Order.new(params[:order])
    @order.customer_ip = request.remote_ip
    @order.status = 'open'
    
    @order.line_items << @cart.items
    respond_to do |format|
      format.html {
        if @order.save
          if @order.process
            flash[:notice] = 'Your order has been submitted'
            session[:order_id] = @order.id
          else
            flash[:notice] = 'Some error occured'
            render :action => 'new'
          end
        else
          render :action => 'new'
        end
      }
    end
  end

end
