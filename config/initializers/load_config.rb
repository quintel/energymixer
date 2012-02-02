APP_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env].with_indifferent_access
APP_NAME = APP_CONFIG[:app_name]

# Airbrake setup requires APP_CONFIG
#
Airbrake.configure do |config|
  config.api_key = APP_CONFIG[:airbrake_key]
end if APP_CONFIG[:airbrake_key] && !APP_CONFIG[:standalone]
