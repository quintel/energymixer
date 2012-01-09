require 'bundler/capistrano'

load 'deploy'
load 'lib/capistrano/db_recipes'
load 'lib/capistrano/airbrake'
load 'lib/capistrano/bluepill'
load 'lib/capistrano/link_config'
load 'lib/capistrano/mixer'

set :scm, :git
set :repository,  "git@github.com:dennisschoenmakers/energymixer.git"
set :user, 'ubuntu'
set :deploy_to, "/home/ubuntu/apps/#{application}"
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true
set :use_sudo, false

server 'mixer.et-model.com', :web, :app, :db, :primary => true
set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"
set :local_db_name, 'energymixer_dev'

task :gasmixer do
  set :application, "gasmixer"
  set :branch, "gasmixer"
  set :db_name, "gasmixer"
  set :db_user, "gasmixer"
  set :db_pass, "IpoYWWV00DREjh"
end

task :mixer do
  set :application, "mixer"
  set :branch, "mixer"
  set :db_name, "energymixer"
  set :db_user, "energymixer"
  set :db_pass, "sKkE6qyst0jCUN"
end

# Symlink database.yml, etc.
after  'deploy:update_code', 'deploy:link_config'
after  'deploy:restart',     'bluepill:restart_monitored'
after  'deploy',             'airbrake:notify'
