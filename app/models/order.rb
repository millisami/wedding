# == Schema Info
# Schema version: 20090105070802
#
# Table name: orders
#
#  id                  :integer(4)      not null, primary key
#  customer_ip         :string(255)
#  email               :string(255)
#  error_message       :string(255)
#  invoice_number      :string(255)
#  message             :text
#  phone_number        :string(255)
#  ship_to_address1    :string(255)
#  ship_to_address2    :string(255)
#  ship_to_city        :string(255)
#  ship_to_country     :string(255)
#  ship_to_first_name  :string(255)
#  ship_to_last_name   :string(255)
#  ship_to_postal_code :string(255)
#  status              :string(255)
#  created_at          :datetime
#  updated_at          :datetime

class Order < ActiveRecord::Base
  attr_protected :id, :customer_ip, :status, :error_message
  attr_accessor :card_type, :card_number, :card_expiration_month, :card_expiration_year, :card_verification_value
	has_many :line_items
  #has_many :products, :through => :line_items

  #Validations
  validates_size_of :line_items, :minimum => 1
  validates_length_of :ship_to_first_name, :in => 2..255
  validates_length_of :ship_to_last_name, :in => 2..255
  validates_length_of :ship_to_address1, :in => 2..255
  validates_length_of :ship_to_address2, :in => 2..255
  validates_length_of :ship_to_city, :in => 2..255
  validates_length_of :ship_to_postal_code, :in => 2..255
  validates_length_of :ship_to_country, :in => 2..255

  validates_length_of :phone_number, :in => 7..20
  validates_length_of :customer_ip, :in => 7..15
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_inclusion_of :status, :in => %w(open processed closed failed)
  validates_inclusion_of :card_type, :in => ['Visa', 'MasterCard', 'Discover'], :on => :create
  validates_length_of :card_number, :in => 13..19, :on => :create
  validates_inclusion_of :card_expiration_month, :in => %w(1 2 3 4 5 6 7 8 9 10 11 12), :on => :create
  validates_inclusion_of :card_expiration_year, :in => %w(2006 2007 2008 2009 2010), :on => :create
  validates_length_of :card_verification_value, :in => 3..4, :on => :create

  def process
    return true
    raise "Order is closed" if closed?
    begin
      process_with_active_merchant
    rescue => e
      logger.error("Order #{id} failed with error message #{e}")
      self.error_message = 'Error while processing order'
      self.status = 'failed'
      save!
      self.status = 'processed'
    end
  end
  
  def paypal_url(return_url)
    values = {
      :business => 'seller_dddh@gmail.com',
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => id
    }
    line_items.each_with_index do |item, index|
      values.merge!({
          "amount_#{index+1}" => item.price,
          "item_name_#{index+1}" => item.product.name,
          "item_number_#{index+1}" => item.id,
          "quantity_#{index+1}" => item.quantity
      })
    end
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.map {|k, v| "#{k}=#{v}"}.join("&")
  end

  def process_with_active_merchant
    Base.gateway_mode = :test
    gateway = PaypalGateway.new(
      :login => 'business_account_login',
      :password => 'business_account_password',
      :cert_path => File.join(File.dirname(__FILE__), "../../config/paypal")
    )
    gateway.connection.wiredump_dev = STDERR
    creditcard = CreditCard.new(
      :type => card_type,
      :number => card_number,
      :verification_value => card_verification_value,
      :month => card_expiration_month,
      :year => card_expiration_year,
      :first_name => ship_to_first_name,
      :last_name => ship_to_last_name
    )
    # Buyer information
    params = {
      :order_id => self.id,
      :email => email,
      :address => { :address1 => ship_to_address,
        :city => ship_to_city,
        :country => ship_to_country,
        :zip => ship_to_postal_code
      } ,
      :description => 'Books',
      :ip => customer_ip
    }
    response = gateway.purchase(total, creditcard, params)
    if response.success?
      self.status = 'processed'
    else
      self.error_message = response.message
      self.status = 'failed'
    end
  end
end
