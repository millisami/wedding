class Cart
	attr_reader :items
	attr_reader :total_price
	
	def initialize
		empty_all_items
	end

    def add_pdf_xml_data(xml_data)
        doc = Hpricot.XML(xml_data)
        product_id = (doc/:product_id).inner_html.to_i
        existing_item = @items.find {|item|item.product_id == product_id}

        if existing_item
            @xml_file = "#{RAILS_ROOT}/public/pdf_xml_files/#{session.session_id}-#{existing_item.id}-pdf.xml"
            File.open(@xml_file, 'w') do |f|
                # use "\n" for two lines of text
                f.puts xml_data
            end

            existing_item.pdf_xml_data = @xml_file
        end
    end

    def get_pdf_xml_data(product_id)
        existing_item = @items.find {|item|item.product_id == product_id}
        File.read(existing_item.pdf_xml_data) if existing_item
    end

    def get_pdf_xml_data_stripped(product_id)
        existing_item = @items.find {|item|item.product_id == product_id}
        if existing_item && existing_item.pdf_xml_data
            doc = Hpricot.XML(File.read(existing_item.pdf_xml_data))
            (doc/"RadioButtonList").remove
            (doc/"changefonts").remove
            return doc
        end
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
