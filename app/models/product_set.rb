# == Schema Info
# Schema version: 20081129104621
#
# Table name: product_sets
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime

class ProductSet < ActiveRecord::Base
	include Imageable
	
	belongs_to :category
	has_many :products, :dependent => :destroy
	
	validates_presence_of :name, :message => 'ProductSet name cannot be blank'
	validates_length_of :name, :within => 3..255
	#validates_length_of :body, :maximum => 10000
	
end
