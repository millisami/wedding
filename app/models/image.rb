# == Schema Info
# Schema version: 20090105070802
#
# Table name: images
#
#  id           :integer(4)      not null, primary key
#  record_id    :integer(4)
#  content_type :string(255)
#  filename     :string(255)
#  height       :integer(4)
#  record_type  :string(255)
#  size         :integer(4)
#  width        :integer(4)
#  created_at   :datetime
#  updated_at   :datetime

class Image < ActiveRecord::Base
	belongs_to :record, :polymorphic => true
	has_attachment :content_type => :image, 
			:storage => :file_system, 
			:max_size => 500.kilobytes, 
			:processor => 'ImageScience', 
			:path_prefix => 'public/records'
	
	validates_as_attachment
end
