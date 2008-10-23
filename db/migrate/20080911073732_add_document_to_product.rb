class AddDocumentToProduct < ActiveRecord::Migration
  def self.up
	add_column :products, :document_file_name, :string
	add_column :products, :document_content_type, :string
	add_column :products, :document_file_size, :string
  end

  def self.down
	remove_column :products, :document_file_name
	remove_column :products, :document_content_type
	remove_column :products, :document_file_size
  end
end
