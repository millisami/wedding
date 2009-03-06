class PdfTemplatesController < ApplicationController
    protect_from_forgery :except => [:parse]
    layout nil
    #include PdfStamper
    require 'fileutils'
    require 'rjb'
    require 'tmpdir'
    include FileUtils
    load_path = File.join(RAILS_ROOT, 'lib', 'iText-2.1.4.jar')
    options = ['-Djava.awt.headless=true']
    # RJB needs the LD_LIBRARY_PATH and JAVA_HOME environment set for it to work correctly.  For example on my system:
    # export LD_LIBRARY_PATH=/usr/java/jdk1.6.0/jre/lib/i386/:/usr/java/jdk1.6.0/jre/lib/i386/client/:./
    # export JAVA_HOME=/usr/java/jdk1.6.0/

    #ENV['JAVA_HOME'] = 'C:\Program Files\Java\jdk1.6.0_10' if ENV['JAVA_HOME'].nil? and RUBYPLATFORM =~ /mswin32/
    ENV['JAVA_HOME'] = 'C:\Program Files\Java\jdk1.6.0_10' if ENV['JAVA_HOME'].nil?
    Rjb::load load_path, options

    def show
        @product_details = Product.find(params[:id])
        #PUT THIS PRODUCT ID IN THE SESSINO AS NEW_PRODUCT_ID_IN_SESSION
        
        template(@product_details.document.path)
      
        text(:user_id, 13)
        text(:product_id, params[:id])
        @pdf_stamper.close
        send_file_options = {
            :type => 'application/pdf', #@product_details.document.content_type,
            #:length => @product_details.document.size,
            :disposition => 'inline',
            :status => "200 OK"
        }
        if RAILS_ENV == "production"
            send_file(@tmp_path, send_file_options, :x_sendfile => true) and return
        else
            send_file(@tmp_path, send_file_options) and return
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


    def template(pdf = nil, options = {})
        filestream   = Rjb::import('java.io.FileOutputStream')
        pdfreader    = Rjb::import('com.lowagie.text.pdf.PdfReader')
        pdfstamper   = Rjb::import('com.lowagie.text.pdf.PdfStamper')

        pdf_reader = pdfreader.new(pdf)
        @tmp_path = File.join(RAILS_ROOT, 'tmp', 'pdf-stamper-' + rand(10000).to_s + '.pdf')
        file_output_stream = filestream.new(@tmp_path)

        @pdf_stamper = pdfstamper.new(pdf_reader, file_output_stream)
        @form = @pdf_stamper.getAcroFields()
    end

    def text(key, value)
        @form.setField(key.to_s, value.to_s) # Value must be a string or itext will error.
    end

end
