# Email settings
require 'smtp_tls'
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "handmade-weddingcards.com",
  :authentication => :plain,
  :user_name => "millisami@gmail.com",
  :password => "PheriAajA"
}
