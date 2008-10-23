class ProductSet < ActiveRecord::Base
	include Imageable
	
	belongs_to :category
	has_many :products, :dependent => :destroy
	
	validates_presence_of :name, :message => 'ProductSet name cannot be blank'
	validates_length_of :name, :within => 3..255
	#validates_length_of :body, :maximum => 10000
	
end
