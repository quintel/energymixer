config = YAML.load_file(Rails.root.join('config', 'config.yml'))

APP_CONFIG = config['application'][Rails.env].with_indifferent_access

PARTITIONS = config.except('application').
  each_with_object({}) do |(key, conf), partitions|
    partitions[key] = conf[Rails.env]
  end

# Temporary: Required to boot the app while refactoring the "unify" branch.
APP_CONFIG.merge! config['gasmixer'][Rails.env]

# Airbrake setup requires APP_CONFIG.
if APP_CONFIG[:airbrake_key] && ! APP_CONFIG[:standalone]
  Airbrake.configure { |config| config.api_key = APP_CONFIG[:airbrake_key] }
end
