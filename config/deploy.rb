#############################################################
# Application
#############################################################

set :application, "weddingcards"
set :deploy_to, "/home/deploy/#{application}"

#############################################################
# Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, true
set :scm_verbose, true
set :port, 40000

#############################################################
# Servers
#############################################################

set :user, "deploy"
set :user_passphrase, ""
set :domain, "handmade-weddingcards.com"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
# Git
#############################################################

set :scm, :git
set :branch, "master"
#set :scm_user, "GITUSERNAME"
#set :scm_passphrase, "GITPASSWORD"
set :repository, "git://github.com/millisami/weddingcards.git"
set :deploy_via, :remote_cache

#############################################################
# Slicehost Setup
#############################################################

namespace :slicehost do
    desc "Setup Environment"
    task :setup_env do
        update_apt_get
        install_dev_tools
        install_git
        install_sqlite3
        install_rails_stack
        install_apache
        install_passenger
        config_passenger
        config_vhost
    end

    desc "Update apt-get sources"
    task :update_apt_get do
        sudo "apt-get update"
    end

    desc "Install Development Tools"
    task :install_dev_tools do
        sudo "apt-get install build-essential -y"
    end

    desc "Install Git"
    task :install_git do
        sudo "apt-get install git-core git-svn -y"
    end

    desc "Install Subversion"
    task :install_subversion do
        sudo "apt-get install subversion -y"
    end

    desc "Install MySQL"
    task :install_mysql do
        sudo "apt-get install mysql-server libmysql-ruby -y"
    end

    desc "Install PostgreSQL"
    task :install_postgres do
        sudo "apt-get install postgresql libpgsql-ruby -y"
    end

    desc "Install SQLite3"
    task :install_sqlite3 do
        sudo "apt-get install sqlite3 libsqlite3-ruby -y"
    end

    desc "Install Ruby, Gems, and Rails"
    task :install_rails_stack do
        [ "sudo apt-get install ruby ruby1.8-dev irb ri rdoc libopenssl-ruby1.8 -y",
            "mkdir -p src",
            "cd src",
            "wget http://rubyforge.org/frs/download.php/38646/rubygems-1.2.0.tgz",
            "tar xzvf rubygems-1.2.0.tgz",
            "cd rubygems-1.2.0/ && sudo ruby setup.rb",
            "sudo ln -s /usr/bin/gem1.8 /usr/bin/gem",
            "sudo gem update --system",
            "sudo gem install rails --no-ri --no-rdoc"
        ].each {|cmd| run cmd}
    end

    desc "Install MySQL Rails Bindings"
    task :install_mysql_bindings do
        sudo "aptitude install libmysql-ruby1.8"
    end

    desc "Install ImageMagick"
    task :install_imagemagick do
        sudo "apt-get install libxml2-dev libmagick9-dev imagemagick"
        sudo "gem install rmagick"
    end

    desc "Install Apache"
    task :install_apache do
        sudo "apt-get install apache2 apache2.2-common apache2-mpm-prefork apache2-utils libexpat1 apache2-prefork-dev libapr1-dev -y"
        sudo "chown :sudo /var/www"
        sudo "chmod g+w /var/www"
    end

    desc "Install Passenger"
    task :install_passenger do
        run "sudo gem install passenger --no-ri --no-rdoc"
        input = ''
        run "sudo passenger-install-apache2-module" do |ch,stream,out|
            next if out.chomp == input.chomp || out.chomp == ''
            print out
            ch.send_data(input = $stdin.gets) if out =~ /(Enter|ENTER)/
        end
    end

    desc "Configure Passenger"
    task :config_passenger do
        passenger_config =<<-EOF
 LoadModule passenger_module /usr/lib/ruby/gems/1.8/gems/passenger-2.0.3/ext/apache2/mod_passenger.so
 PassengerRoot /usr/lib/ruby/gems/1.8/gems/passenger-2.0.3
 PassengerRuby /usr/bin/ruby1.8
        EOF
        put passenger_config, "src/passenger"
        sudo "mv src/passenger /etc/apache2/conf.d/passenger"
    end

    desc "Configure VHost"
    task :config_vhost do
        vhost_config =<<-EOF
     <VirtualHost *:80>
       ServerName #{domain}
       ServerAlias www.#{domain}
       DocumentRoot #{deploy_to}/current/public
    </VirtualHost>
        EOF
        put vhost_config, "src/vhost_config"
        sudo "mv src/vhost_config /etc/apache2/sites-available/#{application}"
        sudo "a2ensite #{application}"
        sudo "sudo a2enmod rewrite"
    end

    desc "Reload Apache"
    task :apache_reload do
        sudo "/etc/init.d/apache2 reload"
    end
end #end of slicehost namespace

#############################################################
# Deploy for Passenger
#############################################################
namespace :gems do
    desc "Install gems"
    task :install, :roles => :app do
        run "cd #{current_path} && #{sudo} rake RAILS_ENV=production gems:install"
    end
end
namespace :deploy do
    desc "Creating and Symlink the upload directories"
    ##http://groups.google.com/group/capistrano/browse_thread/thread/66a21c5a10206c6a
    task :create_upload_symlink do

        if File.directory?("#{shared_path}/uploads/records")
            run "ln -nsf #{shared_path}/uploads/records #{release_path}/public/records"
        else
            run "mkdir -p #{shared_path}/uploads/records"
            run "ln -nsf #{shared_path}/uploads/records #{release_path}/public/records"
        end
	 
        if File.directory?("#{shared_path}/uploads/documents")
            run "ln -nsf #{shared_path}/uploads/documents #{release_path}/public/documents"
        else
            run "mkdir -p #{shared_path}/uploads/documents"
            run "ln -nsf #{shared_path}/uploads/documents #{release_path}/public/documents"
        end

        if File.directory?("#{shared_path}/uploads/pdf_xml_files")
            run "ln -nsf #{shared_path}/uploads/pdf_xml_files #{release_path}/public/pdf_xml_files"
        else
            run "mkdir -p #{shared_path}/uploads/pdf_xml_files"
            run "ln -nsf #{shared_path}/uploads/pdf_xml_files #{release_path}/public/pdf_xml_files"
        end
        if File.directory?("#{shared_path}/uploads/pdf_xmls")
            run "ln -nsf #{shared_path}/uploads/pdf_xmls #{release_path}/public/pdf_xmls"
        else
            run "mkdir -p #{shared_path}/uploads/pdf_xmls"
            run "ln -nsf #{shared_path}/uploads/pdf_xmls #{release_path}/public/pdf_xmls"
        end
    end

    ##http://groups.google.com/group/capistrano/browse_thread/thread/7d625673d0920fa1
    #But got to replace #{release_path} with #{current_path} to run it manually.
    desc "Create database.yml and app_config.yml in shared/config"
     task :upload_config do
         run "mkdir -p #{shared_path}/config" unless File.exists?("#{shared_path}/config")
       #put(File.read('config/environment.rb'),"#{release_path}/config/environment.rb", :mode => 0744) if File.exists?('config/environment.rb')
       put(File.read('config/database.yml'),"#{current_path}/config/database.yml", :mode => 0744) if File.exists?('config/database.yml')
       put(File.read('config/app_config.yml'),"#{current_path}/config/app_config.yml", :mode => 0744) if File.exists?('config/app_config.yml')
     end

    desc "Symlinking upload directories and *.yml files"
    task :symlink_shared do
            #run "ln -fs #{deploy_to}/shared/sphinx/production/ #{release_path}/db/sphinx/production"
            files=%w(database.yml app_config.yml)
            files.each do |f|
                run "ln -nfs #{shared_path}/config/#{f} #{release_path}/config/#{f}"
            end
            dirs=%(records documents pdf_xmls pdf_xml_files)
            dirs.each do |d|
                run "ln -nsf #{shared_path}/uploads/#{d} #{release_path}/public/#{d}"
            end
    end

    desc "tail production log files"
    task :tail_logs, :roles => :app do
        run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
            puts  # for an extra line break before the host name
            puts "#{channel[:host]}: #{data}" 
            break if stream == :err
        end
    end
    
    desc "remotely console"
    task :console, :roles => :app do
        input = ''
        run "cd #{current_path} && ./script/console #{ENV['RAILS_ENV']}" do |channel, stream, data|
            next if data.chomp == input.chomp || data.chomp == ''
            print data
            channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
        end
    end
    
    desc "Restarting mod_rails with restart.txt"
    task :restart, :roles => :app, :except => { :no_release => true } do
        run "touch #{current_path}/tmp/restart.txt"
    end

    [:start, :stop].each do |t|
        desc "#{t} task is a no-op with mod_rails"
        task t, :roles => :app do ; end
    end
end #deploy namespace end

namespace :passenger do
    desc "Restart Passenger"
    task :restart, :roles => :app do
        run "touch #{current_path}/tmp/restart.txt"
    end

    desc "Stop Passenger"
    task :stop, :roles => :app do
        run "touch #{current_path}/tmp/stop.txt"
    end

    desc "Start (or un-stop) Passenger"
    task :start, :roles => :app do
        run "rm -f #{current_path}/tmp/stop.txt"
    end

    # requires root
    desc "Check memory stats"
    task :memory do
        run "sudo passenger-memory-stats"
    end

    # requires root
    desc "Check status of rails processes"
    task :status do
        run "sudo passenger-status"
    end

end

#after 'deploy:update_code', 'deploy:create_upload_symlink'
after 'deploy:update_code', 'deploy:symlink_shared'
