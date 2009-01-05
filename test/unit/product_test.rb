# == Schema Info
# Schema version: 20090105070802
#
# Table name: products
#
#  id                    :integer(4)      not null, primary key
#  product_set_id        :integer(4)
#  default_qty           :integer(4)      default(35)
#  document_content_type :string(255)
#  document_file_name    :string(255)
#  document_file_size    :string(255)
#  name                  :string(255)
#  price                 :decimal(8, 2)   default(0.0)
#  weight                :float           default(1000.0)
#  created_at            :datetime
#  updated_at            :datetime

require File.dirname(__FILE__) + '/../test_helper'

class ProductTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
