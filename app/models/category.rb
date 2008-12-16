# == Schema Info
# Schema version: 20081129104621
#
# Table name: categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime

class Category < ActiveRecord::Base
	has_many :product_sets
	
	validates_presence_of :name
end
