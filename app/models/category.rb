# == Schema Info
# Schema version: 20090105070802
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
    has_friendly_id :name
end
