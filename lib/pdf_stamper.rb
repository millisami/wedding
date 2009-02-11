require 'fileutils'
require 'rjb'
require 'tmpdir'
include FileUtils
my_path = File.dirname(File.expand_path(__FILE__))
load_path = File.join(my_path, 'lib', 'iText-2.1.4.jar')
if File.exists?(Rails.root.join('lib','iText-2.1.4.jar'))
	options = ['-Djava.awt.headless=true']
	Rjb::load load_path, options
	#======================================================
	filestream   = Rjb::import('java.io.FileOutputStream')
	#pdf_dict = Rjb::import('com.lowagie.text.pdf.PdfDictionary')
	acrofields   = Rjb::import('com.lowagie.text.pdf.AcroFields')
	#acrofieldsitem   = Rjb::import('com.lowagie.text.pdf.AcroFields.Item')
	pdfreader    = Rjb::import('com.lowagie.text.pdf.PdfReader')
	pdfstamper   = Rjb::import('com.lowagie.text.pdf.PdfStamper')
	xfaform = Rjb::import('com.lowagie.text.pdf.XfaForm')
	hashmap = Rjb::import('java.util.HashMap')
	iterator = Rjb::import('java.util.Iterator')
	string = Rjb::import('java.lang.String')
	pracroform  = Rjb::import('com.lowagie.text.pdf.PRAcroForm')
	#======================================================

	#pdf_reader = pdfreader.new("tasks.pdf")
	pdf_reader = pdfreader.new("response_template.pdf")
	#pdf_reader = pdfreader.new("invitation_template.pdf")
	#pdf_reader = pdfreader.new("name_card_template.pdf")
	@tmp_path = File.join(Dir::tmpdir, 'pdf-stamper-' + rand(10000).to_s + '.pdf')
	file_output_stream = filestream.new(@tmp_path)

	xfa_form = xfaform.new(pdf_reader)
	if (!xfa_form.isXfaPresent())
		puts "No, it is not xfa form"
	else
		puts "Yes it is xfa"
	end
	pdf_stamper = pdfstamper.new(pdf_reader, file_output_stream)
	if( pdf_stamper.getAcroFields().getFields().size() != 0 ) # then use the "old" way
		puts "Has AcroFields"
		puts pdf_stamper.getAcroFields().getFields().size().to_s + " number of fields"
	end

	@form = pdf_stamper.getAcroFields()
	@form.setField("bodytext", "Modified body text")
	@form.setField("response","Sachin Sagar")
	pdf_stamper.close
	mv(@tmp_path, "my_output5.pdf") # NOTE what if someone tries to duplicate the file by saving twice?
	@tmp_path = "my_output5.pdf"
end