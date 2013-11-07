source 'http://rubygems.org'

gem 'rails', '3.2.13'

gem 'mysql2',       '~> 0.3.11'
gem 'devise',       '~> 1.4.5'
gem 'jquery-rails', '~> 1.0.19'
gem 'simple_form',  '~> 2.1.0'
gem 'kaminari',     '~> 0.13.0'
gem 'bluecloth',    '~> 2.1.0'
gem 'dynamic_form', '~> 1.1.3'
gem 'client_side_validations', '~> 3.2.6'
gem 'client_side_validations-simple_form', '~> 2.1.0'
gem 'airbrake', '~> 3.0.9'
gem 'httparty', '~> 0.9.0'
gem 'haml',   '~> 3.1.4'
gem 'tabs_on_rails'
gem 'memcache-client'
gem 'jbuilder'
gem "jquery-etmodel-rails", '~> 0.3', :github => "quintel/etplugin"
gem 'capistrano'

group :development, :test do
  gem 'rspec-rails',        '~> 2.13.0'
  gem 'factory_girl_rails'
  gem 'pry'

  gem "bourne", ">= 1.4.0"
  # Use stable version when shoulda-matchers > 1.5.0 gets released
  gem "shoulda-matchers", github: "thoughtbot/shoulda-matchers", branch: "dc-bourne-dependency", require: false
  gem "mocha", ">= 0.13.3", require: false
  # gem 'mocha',              '~> 0.10.0'
end

group :development do
  gem 'hirb'
  gem 'awesome_print', :require => 'ap'
  gem 'annotate', :require => false
  gem 'guard'
  gem 'pry-remote'
end

group :production do
  # Use unicorn as the web server
  gem 'unicorn'
end

group :test do
  gem 'simplecov', '~> 0.5.3', :require => false
  gem 'guard-rspec'
  gem 'spork'
  gem 'guard-spork'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
end

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'sass-rails', '~> 3.2.3'
  gem 'therubyracer', '~> 0.11.3'
  gem 'libv8', '~> 3.11.8'
  gem 'uglifier'
  gem 'yui-compressor'
end
