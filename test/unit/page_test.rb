# == Schema Info
# Schema version: 20081129104621
#
# Table name: pages
#
#  id         :integer(4)      not null, primary key
#  body       :text
#  position   :integer(4)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime

require File.dirname(__FILE__) + '/../test_helper'

class PageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
