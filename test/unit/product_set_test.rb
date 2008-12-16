# == Schema Info
# Schema version: 20081129104621
#
# Table name: product_sets
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime

require 'test_helper'

class ProductSetTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
