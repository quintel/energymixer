APP_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env]
APP_NAME = APP_CONFIG['app_name']
