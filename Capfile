load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :deploy do
  task :after_update_code do
    run "cp /home/ubuntu/config_files/database.yml #{release_path}/config/database.yml"
  end

  task :start do 
    # otherwise deploy:cold won't work
  end

  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :rake do
  desc "Reset production db loading seeds file"
  task :db_reset do
    run("cd #{deploy_to}/current && /usr/bin/env rake db:reset RAILS_ENV=production")
  end
end