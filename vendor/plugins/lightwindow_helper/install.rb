require 'fileutils'
%w(stylesheets images javascripts).each do |type|
  dir  = File.join(File.dirname(__FILE__), 'assets', type)
  dest = File.join(File.dirname(__FILE__), '/../../../public')
  FileUtils.cp_r(dir, dest) #if !File.exist?(dir)
end
puts IO.read(File.join(File.dirname(__FILE__), 'README'))
