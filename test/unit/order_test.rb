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

require File.dirname(__FILE__) + '/../test_helper'

class OrderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_that_we_can_create_a_valid_order
    order = Order.new(
      #Contact Info
      :email => 'sachin@gmail.com',
      :phone_number => '32483578343245235432',
      #Shipping
      :ship_to_first_name => 'Sachin',
      :ship_to_last_name => 'Sagar',
      :ship_to_address1 => 'Lazimpat',
      :ship_to_address2 => 'Laz',
      :ship_to_city => 'Kathmandu',
      :ship_to_country => 'Nepal',
      :ship_to_postal_code => 'P Code',
      #Billing
      :card_type => 'Visa',
      :card_number => '4007000000027',
      :card_expiration_month => '1',
      :card_expiration_year => '2010',
      :card_verification_value => '333'
    )
    #Private parts
    order.customer_ip = '10.10.10.1',
      order.status = 'processed',

      order.line_items << LineItem.new(
        :product_id => 1,
        :price => 100.55,
        :quantity => 12
    )
    assert order.save
    order.reload
    assert_equal 1, order.line_items.size
    assert_equal 100.55, order.order_items[0].price
  end
end
