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

class Order < ActiveRecord::Base
	has_many :line_items
end
