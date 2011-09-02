APP_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env]
END_YEAR   = APP_CONFIG['api_session_settings'][:end_year]
