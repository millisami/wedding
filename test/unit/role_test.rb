# == Schema Info
# Schema version: 20090105070802
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime

require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
