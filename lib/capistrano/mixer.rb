
namespace :rake_tasks do
  desc "Recreates the average scenarios"
  task :average_scenarios do
    run("cd #{deploy_to}/current && /usr/bin/env rake scenarios:create_average RAILS_ENV=production")
  end

  desc "Clears cache"
  task :clear_cache do
    run("cd #{deploy_to}/current && /usr/bin/env rake scenarios:clear_cache RAILS_ENV=production")
  end
end

