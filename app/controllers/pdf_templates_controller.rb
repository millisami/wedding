class PdfTemplatesController < ApplicationController
    protect_from_forgery :except => [:parse]
    layout nil
    

    def show
        @product_details = Product.find(params[:id])
        rand_value = rand(1000000).to_s
        @xml_file_striped = File.join(RAILS_ROOT, 'tmp', 'output-pdf-xml-file-striped' + rand_value + '.xml')
        @output_pdf_file_first = File.join(RAILS_ROOT, 'tmp', 'output-pdf-file-first-' + rand_value + '.pdf')
        doc = Hpricot.XML(File.read(@product_details.pdf_xml.path))
        (doc/"product_id").inner_html = @product_details.id.to_s
        (doc/"user_id").inner_html = current_user.id.to_s if logged_in?

        debugger

        doc2 = XML::Document.new
        doc2.root = XML::Node.new('form1')
        doc2.root << changefonts = XML::Node.new('changefonts')
        changefonts.content = (doc/"changefonts").inner_html
        doc2.root << radio_button_list = XML::Node.new('RadioButtonList')
        radio_button_list.content = (doc/"RadioButtonList").inner_html
        doc2.root << product_id = XML::Node.new('product_id')
        product_id.content = @product_details.id.to_s
        doc2.root << user_id = XML::Node.new("user_id")
        user_id.content = current_user.id.to_s if logged_in?

         File.open(@xml_file_striped, 'w') do |f|
            f.puts doc2
         end
        debugger
        if RAILS_ENV == "production"
            sys_command = "mono "
        else
            sys_command = "cmd.exe /c "
        end
        
        sys_command << "#{RAILS_ROOT}/lib/Pravat.exe -i=#{@product_details.document.path} -x=#{@xml_file_striped} -d=#{@output_pdf_file_first}"
        #debugger
        system(sys_command)

        @xml_file = File.join(RAILS_ROOT, 'tmp', 'output-pdf-xml-file' + rand_value + '.xml')
        @output_pdf_file = File.join(RAILS_ROOT, 'tmp', 'output-pdf-file-' + rand_value + '.pdf')

        (doc/"RadioButtonList").remove
        (doc/"changefonts").remove

         File.open(@xml_file, 'w') do |f|
            f.puts doc
         end
        debugger
        if RAILS_ENV == "production"
            sys_command = "mono "
        else
            sys_command = "cmd.exe /c "
        end

        sys_command << "#{RAILS_ROOT}/lib/Pravat.exe -i=#{@output_pdf_file_first} -x=#{@xml_file} -d=#{@output_pdf_file}"
        #debugger
        system(sys_command)
        send_file_options = {
            :type => 'application/pdf', #@product_details.document.content_type,
            #:length => @product_details.document.size,
            :disposition => 'inline',
            :status => "200 OK"
        }
#        if RAILS_ENV == "production"
#            send_file(@output_pdf_file, send_file_options, :x_sendfile => true) and return
#        else
#            send_file(@output_pdf_file, send_file_options) and return
#        end
send_file(@output_pdf_file, send_file_options) and return
    end

    def preview
        @product_details = Product.find(params[:id])
        #re-render but without the <RadioButtonList> and <changefonts> omitted
        xml_data = @cart.get_pdf_xml_data_stripped(@product_details.id)
        @xml_file = "#{RAILS_ROOT}/tmp/#{session.session_id}-#{@product_details.id}-pdf-stripped.xml"
        @output_file_first = "#{RAILS_ROOT}/tmp/#{session.session_id}-#{@product_details.id}-first-output.pdf"

        File.open(@xml_file, 'w') do |f|
           # use "\n" for two lines of text
           f.puts xml_data
         end

        #system('cmd.exe /c rake')
        if RAILS_ENV == "production"
            sys_command = "mono "
        else
            sys_command = "cmd.exe /c "
        end
        sys_command << "#{RAILS_ROOT}/lib/Pravat.exe -i=#{@product_details.document.path} -x=#{@xml_file} -d=#{@output_file_first}"
        system(sys_command)

        #debugger
        xml_data = @cart.get_pdf_xml_data(@product_details.id)
        @xml_file = "#{RAILS_ROOT}/tmp/#{session.session_id}-#{@product_details.id}-pdf.xml"
        @output_file = "#{RAILS_ROOT}/tmp/#{session.session_id}-#{@product_details.id}-output.pdf"

        File.open(@xml_file, 'w') do |f|
           # use "\n" for two lines of text
           f.puts xml_data
         end
        debugger
        if RAILS_ENV == "production"
            sys_command = "mono "
        else
            sys_command = "cmd.exe /c "
        end
        sys_command << "#{RAILS_ROOT}/lib/Pravat.exe -i=#{@output_file_first} -x=#{@xml_file} -d=#{@output_file}"
        system(sys_command)
        
#        render :text => "Preview done"
#        return
#
        send_file_options = {
            :type => 'application/pdf', #@product_details.document.content_type,
            #:length => @product_details.document.size,
            :disposition => 'inline',
            :status => "200 OK"
        }
        if RAILS_ENV == "production"
            send_file(@output_file, send_file_options, :x_sendfile => true) and return
        else
            send_file(@output_file, send_file_options) and return
        end

    end

    def parse
        #THE INCOMING PARAMS IS OF THE PRODUCT IN THE SESSION CART
        
        @cart.add_pdf_xml_data(request.raw_post, session.session_id)
        respond_to do |format|
            format.html do
                render :text => "pdf data parsed and added"
            end
		end
    end
end
