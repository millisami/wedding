class ShippingRate < ActiveRecord::Base
    def self.shipping_total(weight)
        first(:select => :rate_euro, :conditions => ["weight >= ?", weight])
    end
end
