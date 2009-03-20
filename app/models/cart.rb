class Cart
	attr_reader :items
	attr_reader :total_price
    attr_reader :converted_total_price
    attr_accessor :exchange_currency
	
	def initialize
		empty_all_items
	end

    def get_quantity(product_id)
        existing_item = @items.find {|item|item.product_id == product_id}
        if existing_item
            return existing_item.quantity
        else
            return ""
        end
    end

    def can_order
        @items.each do |item|
            if item.pdf_xml_data.blank?
                return false
            end
        end
        return true
    end

    def is_pdf_customized(product_id)
        existing_item = @items.find {|item|item.product_id == product_id}
        if existing_item && existing_item.pdf_xml_data
            return true
        else
            return false
        end
    end

    def needs_customization(product_id)
        existing_item = @items.find {|item|item.product_id == product_id}
        if existing_item && existing_item.pdf_xml_data.blank?
            return true
        else
            return false
        end
    end

    def add_pdf_xml_data(xml_data, session_id)
        doc = Hpricot.XML(xml_data)
        product_id = (doc/"product_id").inner_html.to_i
        existing_item = @items.find {|item|item.product_id == product_id}
        debugger

        if existing_item
            @xml_file = "#{RAILS_ROOT}/public/pdf_xml_files/#{session_id}-#{existing_item.product_id}-pdf.xml"
            File.open(@xml_file, 'w') do |f|
                # use "\n" for two lines of text
                f.puts xml_data
            end

            existing_item.pdf_xml_data = @xml_file
            debugger
        end
    end

    def get_pdf_xml_data(product_id)
        existing_item = @items.find {|item|item.product_id == product_id}
        doc = Hpricot.XML(File.read(existing_item.pdf_xml_data)) if existing_item
        (doc/"RadioButtonList").remove
        (doc/"changefonts").remove
        return doc
    end

    def get_pdf_xml_data_stripped(product_id)
        existing_item = @items.find {|item|item.product_id == product_id}
        if existing_item && existing_item.pdf_xml_data
            doc = Hpricot.XML(File.read(existing_item.pdf_xml_data))

            doc2 = XML::Document.new
            doc2.root = XML::Node.new('form1')
            doc2.root << changefonts = XML::Node.new('changefonts')
            changefonts.content = (doc/"changefonts").inner_html
            doc2.root << radio_button_list = XML::Node.new('RadioButtonList')
            radio_button_list.content = (doc/"RadioButtonList").inner_html
            
            return doc2
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
        convert_total_price
	end

	def remove_product(product)
        existing_item = @items.find {|item|item.product_id == product.id}
        if existing_item
            @total_price -= existing_item.quantity.to_i * existing_item.price.to_f
            convert_total_price
            @items.delete(existing_item)
            File.delete(existing_item.pdf_xml_data) if File.exist?(existing_item.pdf_xml_data.to_s)
        end
	end

	def update_quantity(product, quantity)
        existing_item = @items.find {|item|item.product_id == product.id}
        if existing_item
            existing_item.quantity = quantity.to_i
            @total_price = product.price.to_f * quantity.to_i
            convert_total_price
        else
            self.add_product(product, quantity)
        end
	end

	def save_cart
	    
	end

	def empty_all_items
        @items = []
        @total_price = 0.0
        @converted_total_price = 0.0
	end
    
    def calculate_price(price)
        CurrencyExchange.currency_exchange(price, "EUR", @exchange_currency).to_f
    end

    protected
    
    def convert_total_price
        @converted_total_price=CurrencyExchange.currency_exchange(@total_price, "EUR", @exchange_currency)
    end
end
