APP_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env].with_indifferent_access
APP_NAME = APP_CONFIG[:app_name]
