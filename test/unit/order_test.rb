# == Schema Info
# Schema version: 20081129104621
#
# Table name: orders
#
#  id             :integer(4)      not null, primary key
#  user_id        :integer(4)
#  invoice_number :string(255)
#  pay_type       :string(255)
#  status         :string(255)
#  created_at     :datetime
#  updated_at     :datetime

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
