set :application,  "handmade-weddingcards.com"

set :user, "deploy"
set :runner, user
#set :use_sudo, true

set :spinner, false

#from #http://github.com/guides/deploying-with-capistrano
default_run_options[:pty] = true
set :repository,  "git@github.com:millisami/weddingcards.git"
set :scm, "git"
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
    send(run_method, "`readlink#{current_path}`/script/process/reaper")
    sudo "/etc/init.d/thin restart"
  end
end

after "deploy", "deploy:cleanup"
after "deploy:cleanup", "nginx:reload"
after "nginx:reload", "thin:restart"
after "deploy:migrations", "deploy:cleanup"
#after "thin:restart", "cron:stop"
#after "cron:stop", "cron:start"
