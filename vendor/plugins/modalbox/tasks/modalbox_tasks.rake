namespace :modalbox do
  desc "Use this task to copy the assets file"
  task :setup do
    puts "Copying files..."
    #dir = "javascripts"
    %w(stylesheets images javascripts).each do |type|
      dest_dir = File.join(RAILS_ROOT, "public", type)
      src_file = File.join(File.expand_path(File.dirname(__FILE__)), "../assets")
      FileUtils.cp_r(src_file, dest_dir)
    end
    puts "Files copied - Installation complete!"
  end
end
