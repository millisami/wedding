# == Schema Info
# Schema version: 20090105070802
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
end
