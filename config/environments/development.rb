# Settings specified here will take precedence over those in config/environment.rb

SITE_URL = "localhost:3000"

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
#config.action_view.cache_template_extensions         = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
  ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
    :login => "handma_1232606255_biz_api1.gmail.com",
    :password => "1232606281",
    :signature => "AQJBdjpcRyV6ec4yJz74ZOnUNlbGAyP85u6SZbfS4menEEnxcXFhnjX0"
  )
end