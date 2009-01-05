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

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
