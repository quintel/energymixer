require 'bundler/capistrano'

set :application, "energymixer"

set :stage, :production

set :domain, "79.125.109.178"
role :web, domain # Your HTTP server, Apache/etc
role :app, domain # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

set :user, 'ubuntu'


set :deploy_to, "/home/ubuntu/apps/#{application}"
set :config_files, "/home/ubuntu/config_files"

set :scm, :git
set :repository,  "git@github.com:dennisschoenmakers/energymixer.git"
set :scm, "git"
set :deploy_via, :remote_cache
set :chmod755, "app config db lib public vendor script script/* public/disp*"  	# Some files that will need proper permissions set :use_sudo, false
set :git_enable_submodules, 1
set :branch, "master"
ssh_options[:forward_agent] = true


set :use_sudo,     false

set :rvm_ruby_string, '1.9.2'

require './config/boot'
require 'hoptoad_notifier/capistrano'
