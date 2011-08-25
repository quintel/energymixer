#Load subdirectories in config/locales
config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')]

# Use AR store if key is available, otherwise fallback on YAML
I18n.backend = I18n::Backend::Chain.new(I18n::Backend::ActiveRecord.new, I18n.backend)