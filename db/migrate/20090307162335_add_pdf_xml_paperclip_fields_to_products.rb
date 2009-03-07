class AddPdfXmlPaperclipFieldsToProducts < ActiveRecord::Migration
  def self.up
      add_column :products, :pdf_xml_file_name, :string
      add_column :products, :pdf_xml_content_type, :string
      add_column :products, :pdf_xml_file_size, :string
  end

  def self.down
      remove_column :products, :pdf_xml_file_name
      remove_column :products, :pdf_xml_file_type
      remove_column :products, :pdf_xml_file_size
  end
end
