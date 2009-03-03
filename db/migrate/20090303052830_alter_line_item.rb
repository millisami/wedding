class AlterLineItem < ActiveRecord::Migration
  def self.up
      rename_column :line_items, :pdf_data, :pdf_xml_data
  end

  def self.down
      rename_column :line_items, :pdf_xml_data, :pdf_data
  end
end
