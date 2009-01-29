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
  has_many :transactions, :class_name => 'OrderTransaction'
  has_one :payment_notification

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
  validates_inclusion_of :payment_type, :in => %w(CreditCard Paypal Invoice), :message => "must be chosen for a successful checkout"

  validates_inclusion_of :card_type, :in => ['Visa', 'MasterCard', 'Discover'], :on => :create, :if => :payment_type_credit_card
  validates_length_of :card_number, :in => 13..19, :on => :create, :if => :payment_type_credit_card
  validates_inclusion_of :card_expiration_month, :in => %w(1 2 3 4 5 6 7 8 9 10 11 12), :on => :create, :if => :payment_type_credit_card
  validates_inclusion_of :card_expiration_year, :in => %w(2009 2010 2011 2012 2013 2014), :on => :create, :if => :payment_type_credit_card
  validates_length_of :card_verification_value, :in => 3..4, :on => :create, :if => :payment_type_credit_card

  def payment_type_credit_card
    payment_type == "CreditCard"
  end

  def process
   # begin
      #debugger
      
      process_with_active_merchant if self.payment_type == "CreditCard"
      process_with_invoice if self.payment_type == "Invoice"
      debugger
    #rescue => e
#      logger.error("Order #{id} failed with error message #{e}")
#      self.error_message = 'Error while processing order'
#      self.status = 'failed'
#      save!
   # end
  end

  def paypal_url(return_url, notify_url, order_id)
    values = {
      #Seller Password: 232606200
      #Seller ID: handma_1232606255_biz@gmail.com

      #Buyer Password 232549441
      #Buyer ID:buyer_1232549492_per@gmail.com
      #Test CC Number 4628438176984728
      #CVC Use any 3 digits like 123
      :business => APP_CONFIG[:paypal_email],
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => id,
      :notify_url => notify_url,
      :custom => order_id,
      :shipping => 100
    }
    line_items.each_with_index do |item, index|
      values.merge!({
          "amount_#{index+1}" => item.price,
          "item_name_#{index+1}" => item.product.name,
          "item_number_#{index+1}" => item.id,
          "quantity_#{index+1}" => item.quantity
        })
    end
    
    APP_CONFIG[:paypal_url] + values.map {|k, v| "#{k}=#{v}"}.join("&")
    
  end

  def process_with_active_merchant
    debugger
    credit_card = ActiveMerchant::Billing::CreditCard.new(
      :type => card_type,
      :number => card_number,
      :verification_value => card_verification_value,
      :month => card_expiration_month,
      :year => card_expiration_year,
      :first_name => ship_to_first_name,
      :last_name => ship_to_last_name
    )
    # Buyer information
    purchase_options = {
      :order_id => self.id,
      :email => email,
      :address => {
        :address1 => ship_to_address1,
        :address2 => ship_to_address2,
        :city => ship_to_city,
        :country => ship_to_country,
        :zip => ship_to_postal_code
      },
      :description => message,
      :ip => customer_ip
    }
    if credit_card.valid?
      response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
      transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)

      if response.success?
        self.update_attribute(:purchased_at, Time.now)
        self.update_attribute(:status, 'processed')
      else
        self.update_attribute(:error_message, response.message)
        self.update_attribute(:status, 'failed')
      end
    end
  end

  def price_in_cents
    (@cart.total_price*100).round
  end
end
