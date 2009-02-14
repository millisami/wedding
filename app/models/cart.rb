class Cart
	attr_reader :items
	attr_reader :total_price
	
	def initialize
		empty_all_items
	end

    def add_pdf_data(product_id, pdf_data)
        debugger
        existing_item = @items.find {|item|item.product_id == product_id}
        debugger
        if existing_item
            existing_item.pdf_data = pdf_data
        end
        debugger
    end

	def add_product(product, quantity)
        existing_item = @items.find {|item|item.product_id == product.id}
        if existing_item
            existing_item.quantity += quantity
        else
            @items << LineItem.new_based_on(product, quantity)
        end
        @total_price += product.price * quantity
	end

	def remove_product(product)
        existing_item = @items.find {|item|item.product_id == product.id}
        if existing_item
            @total_price -= existing_item.quantity.to_i * existing_item.price.to_f
            @items.delete(existing_item)
        end
	end

	def update_quantity(product, quantity)
        existing_item = @items.find {|item|item.product_id == product.id}
        if existing_item
            existing_item.quantity = quantity.to_i
            @total_price = product.price.to_f * quantity.to_i
        else
            self.add_product(product)
        end
	end

	def save_cart
	    
	end

	def empty_all_items
        @items = []
        @total_price = 0.0
	end
end
