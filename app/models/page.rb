# == Schema Info
# Schema version: 20090105070802
#
# Table name: pages
#
#  id         :integer(4)      not null, primary key
#  body       :text
#  position   :integer(4)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime

class Page < ActiveRecord::Base
  acts_as_list
end
