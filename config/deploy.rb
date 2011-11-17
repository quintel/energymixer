require 'bundler/capistrano'
require 'airbrake/capistrano'

set :application, "energymixer"
set :scm, :git
set :repository,  "git@github.com:dennisschoenmakers/energymixer.git"

set :user, 'ubuntu'
set :deploy_to, "/home/ubuntu/apps/#{application}"
set :deploy_via, :remote_cache
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :git_enable_submodules, 1
ssh_options[:forward_agent] = true
set :use_sudo, false
set :rvm_ruby_string, '1.9.2'


set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"

set :local_db_name, 'energymixer_dev'

task :gasmixer do
  set :domain, "46.137.111.149"
  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
  set :branch, "gasmixer"
  set :db_name, "gasmixer"
  set :db_user, "root"
  set :db_pass, "quintel"
end

task :mixer do
  set :domain, "46.137.156.254"
  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
  set :branch, "mixer"
  set :db_name, "energymixer"
  set :db_user, "energymixer"
  set :db_pass, "sKkE6qyst0jCUN"
end

namespace :deploy do
  task :symlink_shared do
    run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -s #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

require './config/boot'
