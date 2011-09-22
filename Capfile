load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'lib/capistrano/db_recipes'
load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :deploy do
  task :start do 
    # otherwise deploy:cold won't work
  end

  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :rake_tasks do
  desc "Reset production db loading seeds file"
  task :db_reset do
    run("cd #{deploy_to}/current && /usr/bin/env rake db:reset RAILS_ENV=production")
  end

  desc "Recreates the average scenarios"
  task :average_scenarios do
    run("cd #{deploy_to}/current && /usr/bin/env rake scenarios:create_average RAILS_ENV=production")
  end

  desc "Clears cache"
  task :clear_cache do
    run("cd #{deploy_to}/current && /usr/bin/env rake scenarios:clear_cache RAILS_ENV=production")
  end
end
