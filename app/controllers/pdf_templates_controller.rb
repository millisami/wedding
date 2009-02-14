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
        send_file(@tmp_path, send_file_options) and return
    end

    def preview
        @product_details = Product.find(params[:id])
        template(@product_details.document.path)
        text(:response)
        text(:bodytext, "Modified the text by sachin sagar")
    end

    def parse
        @pdf_details = params
        @cart.add_pdf_data(params[:product_id], params)
        
        respond_to do |format|
            format.html do
                render :text => "PDF Data added"
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
