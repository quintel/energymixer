APP_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env]
APP_NAME = APP_CONFIG['app_name']
END_YEAR = APP_CONFIG['api_session_settings'][:end_year]