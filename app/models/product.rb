# == Schema Info
# Schema version: 20090105070802
#
# Table name: products
#
#  id                    :integer(4)      not null, primary key
#  product_set_id        :integer(4)
#  default_qty           :integer(4)      default(35)
#  document_content_type :string(255)
#  document_file_name    :string(255)
#  document_file_size    :string(255)
#  name                  :string(255)
#  price                 :decimal(8, 2)   default(0.0)
#  weight                :float           default(1000.0)
#  created_at            :datetime
#  updated_at            :datetime

class Product < ActiveRecord::Base
	include Imageable
	belongs_to :product_set
	has_many :line_items
	has_attached_file :document
	has_attached_file :pdf_xml
    
	validates_presence_of :name
	validates_numericality_of :price

	validates_attachment_presence :document
    #validates_attachment_content_type :document, :content_type => [ 'application/mp3', 'application/x-mp3' ]
    validates_attachment_size :document, :less_than => 10.megabytes

    protected
    def validate
      errors.add(:price, "should be a positive value") unless price.nil? || price >= 0.01
    end
end
