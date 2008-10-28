default_run_options[:pty] = true

set :application, "handmad-weddingcards.com"
set :repository,  "git@github.com:millisami/weddingcards.git"

set :deploy_to, "/home/deploy/#{application}"
set :user, "deploy"

set :scm, :git

role :app, "handmad-weddingcards.com"
role :web, "handmad-weddingcards.com"
role :db,  "handmad-weddingcards.com", :primary => true

namespace :slicehost do
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

    desc "Install SQLite3"
    task :install_sqlite3 do
      sudo "apt-get install sqlite3 libsqlite3-ruby -y"
    end

    desc "Install Ruby, Gems, and Rails"
    task :install_rails_stack do
      [
	"sudo apt-get install ruby ruby1.8-dev irb ri rdoc libopenssl-ruby1.8 -y",
	"mkdir -p src",
	"cd src",
	"wget http://rubyforge.org/frs/download.php/29548/rubygems-1.0.1.tgz",
	"tar xvzf rubygems-1.0.1.tgz",
	"cd rubygems-1.0.1/ && sudo ruby setup.rb",
	"sudo ln -s /usr/bin/gem1.8 /usr/bin/gem",
	"sudo gem install rails --no-ri --no-rdoc"
      ].each {|cmd| run cmd}
    end

    desc "Install Apache"
    task :install_apache do
      sudo "apt-get install apache2 apache2.2-common apache2-mpm-prefork apache2-utils libexpat1 apache2-prefork-dev libapr1-dev -y"
    end

    desc "Install Passenger"
    task :install_passenger do
      run "sudo gem install passenger --no-ri --no-rdoc"
      input = ''
      run "sudo passenger-install-apache2-module" do |ch,stream,out|
	next if out.chomp == input.chomp || out.chomp == ''
	print out
	ch.send_data(input = $stdin.gets) if out =~ /enter/i
      end
    end

    desc "Configure Passenger"
    task :config_passenger do
      passenger_config =<<-EOF
    LoadModule passenger_module /usr/lib/ruby/gems/1.8/gems/passenger-1.0.1/ext/apache2/mod_passenger.so
    RailsSpawnServer /usr/lib/ruby/gems/1.8/gems/passenger-1.0.1/bin/passenger-spawn-server
    RailsRuby /usr/bin/ruby1.8
      EOF
      put passenger_config, "src/passenger"
      sudo "mv src/passenger /etc/apache2/conf.d/passenger"
    end

    desc "Configure VHost"
    task :config_vhost do
      vhost_config =<<-EOF
    <VirtualHost *:80>
    ServerName handmade-weddingcards.com
    DocumentRoot #{deploy_to}/public
    </VirtualHost>
      EOF
      put vhost_config, "src/vhost_config"
      sudo "mv src/vhost_config /etc/apache2/sites-available/#{application}"
      sudo "a2ensite #{application}"
    end


end

#==================================================================
set :application,  "handmade-weddingcards.com"

set :user, "deploy"
set :runner, user
#set :use_sudo, true
#fixing password prompt issue
#set :sudo, 'sudo -p Password:'

#from #http://github.com/guides/deploying-with-capistrano
default_run_options[:pty] = true
set :repository,  "git@github.com:millisami/weddingcards.git"
set :scm, "git"
set :scm_verbose,  true

#set :scm_passphrase, "***password***" This is your custom users password
#set :user, "***username***"
#set :branch, "master"
set :deploy_via, :remote_cache

set :port, 30000
set :deploy_to, "/home/wedding/public_html/#{application}"          # Where on the server your app will be deployed

set :chmod755, "app config db lib public vendor script script/* public/disp*"  	# Some files that will need proper permissions

role :app, application
role :web, application
role :db,  application, :primary => true

namespace :nginx do
  desc "Reload Nginx"
  task :reload do
    sudo "/etc/init.d/nginx reload"
  end
end

namespace :thin do
  desc "Restart Thin"
  task :restart, :roles => :app do
    sudo "/etc/init.d/thin restart"
  end
end

#overrding capistrano tasks
namespace :deploy do
      task :start, :roles => :app do

    end
      task :stop, :roles => :app do  

    end

    desc <<-DESC
    Restarting Thin via Capistrano overrided :restart task
    DESC
    task :restart, :roles => :app do
      sudo "thin restart -C /etc/thin/handmade-weddingcards.com.yml"
    end
 
end

namespace :millisami do
  # change ownership
  namespace :permissions do
      desc "Custom Namespace Millisami to do native stuff: #{release_path}"
    task :fix, :except => { :no_release => true } do
      sudo "chown -R www-data:www-data #{latest_release}"
    end
  end
end

# Before restarting the webserver we fix all the 
# permissions and then symlink it to production
before 'deploy:restart', 'millisami:permissions:fix' #, 'mikamai:symlink:application'

after "deploy", "deploy:cleanup"
after "deploy:cleanup", "nginx:reload"
#after "nginx:reload", "thin:restart"
after "deploy:migrations", "deploy:cleanup"
