require 'fileutils'
require 'rjb'
require 'tmpdir'
include FileUtils

module PDF
    class Stamper
    def initialize(pdf = nil, options = {})
      @bytearray    = Rjb::import('java.io.ByteArrayOutputStream')
      @filestream   = Rjb::import('java.io.FileOutputStream')
      @acrofields   = Rjb::import('com.lowagie.text.pdf.AcroFields')
      @pdfreader    = Rjb::import('com.lowagie.text.pdf.PdfReader')
      @pdfstamper   = Rjb::import('com.lowagie.text.pdf.PdfStamper')

      template(pdf) if ! pdf.nil?
    end

    def template(template)
      reader = @pdfreader.new(template)
      @baos = @bytearray.new
      @stamp = @pdfstamper.new(reader, @baos)
      @form = @stamp.getAcroFields()
    end

    if File.exists?(Rails.root.join('lib','iText-2.1.4.jar'))
            load_path = Rails.root.join('lib','iText-2.1.4.jar')
            options = ['-Djava.awt.headless=true']
            Rjb::load load_path, options
            #======================================================
            filestream   = Rjb::import('java.io.FileOutputStream')
            acrofields   = Rjb::import('com.lowagie.text.pdf.AcroFields')
            pdfreader    = Rjb::import('com.lowagie.text.pdf.PdfReader')
            pdfstamper   = Rjb::import('com.lowagie.text.pdf.PdfStamper')
	
            pdf_reader = pdfreader.new("response_template.pdf")
            @tmp_path = File.join(Dir::tmpdir, 'pdf-stamper-' + rand(10000).to_s + '.pdf')
            file_output_stream = filestream.new(@tmp_path)

            pdf_stamper = pdfstamper.new(pdf_reader, file_output_stream)
            @form = pdf_stamper.getAcroFields()
            @form.setField("bodytext", "Modified body text")
            @form.setField("response","Sachin Sagar")
            pdf_stamper.close
            mv(@tmp_path, "my_output5.pdf") # NOTE what if someone tries to duplicate the file by saving twice?
            @tmp_path = "my_output5.pdf"
        end
    end
end