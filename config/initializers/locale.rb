# Use AR store if key is available, otherwise fallback on YAML
I18n.backend = I18n::Backend::Chain.new(I18n::Backend::ActiveRecord.new, I18n.backend)