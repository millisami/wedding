class Product < ActiveRecord::Base
	include Imageable
	belongs_to :product_set
	has_many :line_items
	has_attached_file :document
	
	validates_presence_of :name
	validates_numericality_of :price
	validates_uniqueness_of :name
end
