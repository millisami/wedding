class LineItem < ActiveRecord::Base
	belongs_to :order
	belongs_to :product
	
	def self.new_based_on ( product )
		line_item = self.new
		line_item.product = product
		line_item.quantity = 1
		line_item.price = product.price
		return line_item
	end
end
