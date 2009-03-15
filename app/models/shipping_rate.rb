class ShippingRate < ActiveRecord::Base
    def self.shipping_total(weight)
        all(:select => :rate_euro, :conditions => ["weight >= ?", weight], :limit => 1)
    end
end
