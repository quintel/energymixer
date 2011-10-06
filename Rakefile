# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

EnergyMixer::Application.load_tasks

desc "Runs annotate on all models, incl. app/pkg"
task :annotate do
  system "annotate -d"
  system "annotate -p before -e tests, fixtures"
end
