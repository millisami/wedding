# Settings specified here will take precedence over those in config/environment.rb
SITE_URL = "handmade-weddingcards.com"
# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :production
  ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
    :login => "handma_1232606255_biz_api1.gmail.com",
    :password => "1232606281",
    :signature => "AQJBdjpcRyV6ec4yJz74ZOnUNlbGAyP85u6SZbfS4menEEnxcXFhnjX0"
  )
end