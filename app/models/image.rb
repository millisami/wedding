class Image < ActiveRecord::Base
	belongs_to :record, :polymorphic => true
	has_attachment :content_type => :image, 
			:storage => :file_system, 
			:max_size => 500.kilobytes, 
			:processor => 'ImageScience', 
			:path_prefix => 'public/records'
	
	validates_as_attachment
end
