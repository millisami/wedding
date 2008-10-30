set :application,  "handmade-weddingcards.com"

set :user, "deploy"
set :runner, user
#set :use_sudo, true

#set :spinner, false

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

    task :restart, :roles => :app do
      run "touch #{release_path}/tmp"
    end

    desc <<-DESC
    Restarting Thin via Capistrano overrided :restart task
    DESC
    task :restart do
      sudo "thin restart -C /etc/thin/handmade-weddingcards.com.yml"
    end
 
end

namespace :millisami do
  # change ownership
  namespace :permissions do
      desc "Custom Namespace Millisami to do native stuff: #{latest_release}"
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
