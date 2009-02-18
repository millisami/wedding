class AddPdfDataInLineItemModel < ActiveRecord::Migration
  def self.up
      add_column :line_items, :pdf_data, :text
  end

  def self.down
      remove_column :line_items, :pdf_data
  end
end
