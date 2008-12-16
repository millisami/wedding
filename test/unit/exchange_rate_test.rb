# == Schema Info
# Schema version: 20081129104621
#
# Table name: exchange_rates
#
#  id            :integer(4)      not null, primary key
#  base_currency :string(255)
#  currency      :string(255)
#  rate          :float
#  issued_on     :date
#  created_at    :datetime
#  updated_at    :datetime

require 'test_helper'

class ExchangeRateTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
