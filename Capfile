require 'bundler/capistrano'

load 'deploy'
load 'lib/capistrano/db_recipes'
load 'lib/capistrano/airbrake'
load 'lib/capistrano/link_config'
load 'lib/capistrano/mixer'
load 'lib/capistrano/unicorn'

set :application, 'mixer'

set :scm, :git
set :repository, "git@github.com:dennisschoenmakers/energymixer.git"
set :user, 'ubuntu'
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true
set :use_sudo, false

set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"
set :local_db_name, 'energymixer_dev'

task :gasmixer do
  server 'gasmixer.et-model.com', :web, :app, :db, :primary => true
  set :application_name, "gasmixer"
  set :deploy_to, "/home/ubuntu/apps/#{application_name}"
  set :branch, "gasmixer"
  set :db_name, "gasmixer"
  set :db_user, "gasmixer"
  set :db_pass, "IpoYWWV00DREjh"
  set :rvm_ruby_string, "1.9.3@#{application_name}"
end

task :mixer do
  server 'mixer.et-model.com', :web, :app, :db, :primary => true
  set :application_name, "mixer"
  set :deploy_to, "/home/ubuntu/apps/#{application_name}"
  set :branch, "mixer"
  set :db_name, "energymixer"
  set :db_user, "energymixer"
  set :db_pass, "sKkE6qyst0jCUN"
  set :rvm_ruby_string, "1.9.3@#{application_name}"
end

# Symlink database.yml, etc.
after 'deploy:update_code', 'deploy:link_config'
after 'deploy',             'airbrake:notify'

# RVM Stuff ------------------------------------------------------------------

# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano" if ENV['rvm_path'] # Load RVM's capistrano plugin.
set(:bundle_cmd) {"/usr/local/rvm/bin/#{application_name}_bundle"}

