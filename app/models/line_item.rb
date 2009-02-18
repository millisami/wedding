# == Schema Info
# Schema version: 20090105070802
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

class LineItem < ActiveRecord::Base
	belongs_to :order
	belongs_to :product
	
	def self.new_based_on ( product, quantity )
		line_item = self.new
		line_item.product = product
		line_item.quantity = quantity
		line_item.price = product.price
        line_item.pdf_data = nil
		return line_item
	end

  def validate
    errors.add(:quantity, "should be one or more") unless quantity.nil? || quantity > 0
    errors.add(:price, "should be a positive number") unless price.nil? || price > 0.0
  end
end
