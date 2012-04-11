source 'http://rubygems.org'

gem 'rails', '3.2.3'

gem 'mysql2',       '~> 0.3.11'
gem 'devise',       '~> 1.4.5'
gem 'jquery-rails', '~> 1.0.19'
gem 'simple_form',  '~> 1.4.2'
gem 'kaminari',     '~> 0.12.1'
gem 'bluecloth',    '~> 2.1.0'
gem 'dynamic_form', '~> 1.1.3'
gem 'client_side_validations', '~> 3.0.0'
gem 'airbrake', '~> 3.0.9'
gem 'httparty', '~> 0.7.4'
gem 'haml',   '~> 3.1.4'
gem 'tabs_on_rails'
gem 'memcache-client'

gem 'capistrano'

group :development, :test do
  gem 'rspec-rails',        '~> 2.9.0'
  gem 'factory_girl_rails'
  gem 'mocha',              '~> 0.10.0'
  gem 'shoulda',            '~> 2.11.3'
end

group :development do
  gem 'pry'
  gem 'hirb'
  gem 'awesome_print', :require => 'ap'
  gem 'annotate', :require => false
  gem 'guard'
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
end

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'sass-rails', '~> 3.2.3'
  gem 'therubyracer'
  gem 'uglifier'
  gem 'yui-compressor'
end
