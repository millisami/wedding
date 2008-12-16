# == Schema Info
# Schema version: 20081129104621
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
#  created_at            :datetime
#  updated_at            :datetime

class Product < ActiveRecord::Base
	include Imageable
	belongs_to :product_set
	has_many :line_items
	has_attached_file :document
	
	validates_presence_of :name
	validates_numericality_of :price
	#validates_uniqueness_of :name

    protected
    def validate
      errors.add(:price, "should be a positive value") unless price.nil? || price >= 0.01
    end
end
