#
# Copy _error_dump.rhtml to views
#
FileUtils.cp(File.dirname(__FILE__)+'/views/_errordump.rhtml', "#{RAILS_ROOT}/app/views")
