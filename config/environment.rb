# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.active_record.observers = :user_observer

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  
  config.action_controller.session = {
    :session_key => '_handmadeweddingcards_session',
    :secret      => '8287cf5742b553b8e31b5ac00e6c078319c559e7908d857ff286a80e26a8753fab194004b602ba3dfbb78fdd7f6385c35187d47a5b76f49fd672a0fb7a6fe944'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  
  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
	#-- Custom by Millisami
	config.active_record.colorize_logging = false
	config.log_level = :debug

  #gems dependencies
  #config.gem 'RedCloth', :version => '>= 3.0.4', :source => 'http://code.whytheluckystiff.net'
  #config.gem 'aws-s3', :lib => 'aws/s3' #use this syntax for installing gems from github.com
  config.gem 'tzinfo'
  config.gem 'activemerchant', :lib => 'active_merchant', :version => '1.4.1'
  config.gem 'mislav-will_paginate', :version => '~> 2.2.3', :lib => 'will_paginate', :source => 'http://gems.github.com'
  #TODO
  #Add hpricot cnfig.gem used at pdf_templates/cart.rb model controller
  #
  #ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
	#"<span class='field_error'>#{html_tag}</span>"
  #end
#  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
#    if instance.error_message.kind_of?(Array)
#      %(#{html_tag}<span class='validation-error'>&nbsp;
#      #{instance.error_message.join(',')}</span>)
#    else
#      %(#{html_tag}<span class='validation-error'>&nbsp;
#      #{instance.error_message}</span>)
#    end
#  end
end
