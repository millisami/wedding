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

class ExchangeRate < ActiveRecord::Base
end
