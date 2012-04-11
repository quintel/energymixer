require 'bundler/capistrano'
require 'airbrake/capistrano'

load 'deploy'
load 'deploy/assets'
load 'lib/capistrano/db_recipes'
load 'lib/capistrano/link_config'
load 'lib/capistrano/mixer'
load 'lib/capistrano/unicorn'

set :application, 'mixer'

set :scm, :git
set :repository, "git@github.com:dennisschoenmakers/energymixer.git"
set :user, 'ubuntu'
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true
set :bundle_flags, '--deployment --quiet --binstubs --shebang ruby-local-exec'

set :use_sudo, false

set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"
set :local_db_name, 'energymixer_dev'

task :gasmixer do
  server 'gasmixer.et-model.com', :web, :app, :db, :primary => true
  set :application_name, "gasmixer"
  set :deploy_to, "/u/apps/#{application_name}"
  set :branch, "gasmixer"
  set :db_name, "gasmixer"
  set :db_user, "gasmixer"
  set :db_pass, "IpoYWWV00DREjh"
end

task :mixer do
  # Use the right server name ASAP!
  # server 'mixer.et-model.com', :web, :app, :db, :primary => true
  server 'mixer.et-model.com', :web, :app, :db, :primary => true
  set :application_name, "mixer"
  set :deploy_to, "/u/apps/#{application_name}"
  set :branch, "mixer"
  set :db_name, "energymixer"
  set :db_user, "energymixer"
  set :db_pass, "sKkE6qyst0jCUN"
end

# Symlink database.yml, etc.
after 'deploy:update_code', 'deploy:link_config'
before 'deploy:assets:precompile', 'deploy:link_config'

