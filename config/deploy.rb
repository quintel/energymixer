require 'bundler/capistrano'
require 'airbrake/capistrano'

set :application, "energymixer"
set :scm, :git
set :repository,  "git@github.com:dennisschoenmakers/energymixer.git"

set :user, 'ubuntu'
set :deploy_to, "/home/ubuntu/apps/#{application}"
set :config_files, "/home/ubuntu/config_files"
set :deploy_via, :remote_cache
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :git_enable_submodules, 1
ssh_options[:forward_agent] = true
set :use_sudo, false
set :rvm_ruby_string, '1.9.2'

task :to_shell do
  set :domain, "79.125.109.178"
  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
  set :branch, "shell"
end

task :to_gasmixer do
  set :domain, "46.137.111.149"
  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
  set :branch, "gasmixer"
end

task :to_shell2050 do
  set :domain, "ec2-46-137-41-76.eu-west-1.compute.amazonaws.com"
  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
  set :branch, "mixer2050"
end

namespace :deploy do
  task :copy_configuration_files do
    run "cp #{config_files}/database.yml #{release_path}/config/database.yml"
    run "cp #{config_files}/config.yml #{release_path}/config/config.yml"
  end
end

after 'deploy:update_code', 'deploy:copy_configuration_files'

require './config/boot'
