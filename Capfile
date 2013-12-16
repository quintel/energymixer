require 'bundler/capistrano'
require 'airbrake/capistrano'

load 'deploy'
load 'deploy/assets'
load 'lib/capistrano/db_recipes'
load 'lib/capistrano/link_config'
load 'lib/capistrano/mixer'
load 'lib/capistrano/unicorn'

# Reads and returns the contents of a remote +path+, caching it in case of
# multiple calls.
def remote_file(path)
  @remote_files ||= {}
  @remote_files[path] ||= YAML.load(capture("cat #{ path }"))
end

# Reads the remote database.yml file to read the value of an attribute. If a
# matching environment variable is set (prefixed with "DB_"), it will be used
# instead.
def remote_config(file, key)
  ENV["DB_#{ key.to_s.upcase }"] ||
    remote_file("#{ shared_path }/config/#{ file }.yml")[stage.to_s][key.to_s]
end

set :application, 'mixer'
set :stage, :production

set :scm, :git
set :repository, "git@github.com:quintel/energymixer.git"
set :user, 'ubuntu'
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true
set :bundle_flags, '--deployment --quiet --binstubs --shebang ruby-local-exec'

set :use_sudo, false

database_config = File.expand_path('../config/database.yml',__FILE__)
set :local_db_name, YAML.load_file(database_config)["development"]["database"]

task :production do
  server 'mixer.et-model.com', :web, :app, :db, primary: true
  set :application_name, 'energymixer'
  set :deploy_to,        '/u/apps/energymixer'
  set :branch,           'production'

  set :db_host, remote_config(:database, :host) || '127.0.0.1'
  set :db_pass, remote_config(:database, :password)
  set :db_name, remote_config(:database, :database)
  set :db_user, remote_config(:database, :username)
end

task :show do
  %w( db_host db_pass db_name db_user ).each do |meth|
    puts "#{ meth }=#{__send__(meth)}"
  end
end

# Symlink database.yml, etc.
after 'deploy:update_code', 'deploy:link_config'
before 'deploy:assets:precompile', 'deploy:link_config'
