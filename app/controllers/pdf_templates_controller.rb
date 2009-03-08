class PdfTemplatesController < ApplicationController
    protect_from_forgery :except => [:parse]
    layout nil
    

    def show
        @product_details = Product.find(params[:id])
        @xml_file = File.join(RAILS_ROOT, 'tmp', 'output-pdf-xml-file' + rand(1000000).to_s + '.xml')
        @output_pdf_file = File.join(RAILS_ROOT, 'tmp', 'output-pdf-file-' + rand(1000000).to_s + '.pdf')
        doc = Hpricot.XML(File.read(@product_details.pdf_xml.path))
        #(doc/"product_id").remove
        @xml_file = @product_details.pdf_xml.path
        sys_command = "cmd.exe /c #{RAILS_ROOT}/lib/Pravat.exe -i=#{@product_details.document.path} -x=#{@xml_file} -d=#{@output_pdf_file}"
        debugger
        system(sys_command)

        send_file_options = {
            :type => 'application/pdf', #@product_details.document.content_type,
            #:length => @product_details.document.size,
            :disposition => 'inline',
            :status => "200 OK"
        }
        if RAILS_ENV == "production"
            send_file(@output_pdf_file, send_file_options, :x_sendfile => true) and return
        else
            send_file(@output_pdf_file, send_file_options) and return
        end
    end

    def preview
        @product_details = Product.find(params[:id])
        xml_data = @cart.get_pdf_xml_data(@product_details.id)
        @xml_file = "#{RAILS_ROOT}/tmp/#{session.session_id}-#{@product_details.id}-pdf.xml"
        @output_file_first = "#{RAILS_ROOT}/tmp/#{session.session_id}-#{@product_details.id}-first-output.pdf"
        File.open(@xml_file, 'w') do |f|
           # use "\n" for two lines of text
           f.puts xml_data
         end

        #system('cmd.exe /c rake')
        sys_command = "cmd.exe /c #{RAILS_ROOT}/lib/Pravat.exe -i=#{@product_details.document.path} -x=#{@xml_file} -d=#{@output_file_first}"
        debugger
        system(sys_command)

        debugger

        #re-render but without the <RadioButtonList> and <changefonts> omitted
        xml_data = @cart.get_pdf_xml_data_stripped(@product_details.id)
        @xml_file = "#{RAILS_ROOT}/tmp/#{session.session_id}-#{@product_details.id}-pdf.xml"
        @output_file = "#{RAILS_ROOT}/tmp/#{session.session_id}-#{@product_details.id}-output.pdf"
        File.open(@xml_file, 'w') do |f|
           # use "\n" for two lines of text
           f.puts xml_data
         end

        sys_command = "cmd.exe /c #{RAILS_ROOT}/lib/Pravat.exe -i=#{@output_file_first} -x=#{@xml_file} -d=#{@output_file}"
        system(sys_command)
        
        render :text => "Preview done"
#        return
#
#        send_file_options = {
#            :type => 'application/pdf', #@product_details.document.content_type,
#            #:length => @product_details.document.size,
#            :disposition => 'inline',
#            :status => "200 OK"
#        }
#        if RAILS_ENV == "production"
#            send_file(@tmp_path, send_file_options, :x_sendfile => true) and return
#        else
#            send_file(@tmp_path, send_file_options) and return
#        end

    end

    def parse
        #THE INCOMING PARAMS IS OF THE PRODUCT IN THE SESSION CART
        
        @cart.add_pdf_xml_data(request.raw_post)
        respond_to do |format|
            format.html do
                render :text => "pdf data parsed and added"
            end
		end
    end
end
