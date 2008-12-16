# == Schema Info
# Schema version: 20081129104621
#
# Table name: line_items
#
#  id         :integer(4)      not null, primary key
#  order_id   :integer(4)
#  product_id :integer(4)
#  price      :integer(10)
#  quantity   :integer(4)
#  created_at :datetime
#  updated_at :datetime

require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
