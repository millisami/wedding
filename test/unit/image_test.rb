# == Schema Info
# Schema version: 20090105070802
#
# Table name: images
#
#  id           :integer(4)      not null, primary key
#  record_id    :integer(4)
#  content_type :string(255)
#  filename     :string(255)
#  height       :integer(4)
#  record_type  :string(255)
#  size         :integer(4)
#  width        :integer(4)
#  created_at   :datetime
#  updated_at   :datetime

require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
