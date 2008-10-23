class Category < ActiveRecord::Base
	has_many :product_sets
	
	validates_presence_of :name
end
