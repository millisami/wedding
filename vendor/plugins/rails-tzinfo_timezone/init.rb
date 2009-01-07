require 'tzinfo_timezone'

# remove the existing TimeZone constant
if Object.const_defined?(:TimeZone)
  Object.send(:remove_const, :TimeZone)
end

# Use TzinfoTimezone as the TimeZone class
Object::TimeZone = TzinfoTimezone