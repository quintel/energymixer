# Stores setting specific to a subdomain, such as the application name,
# whether to show the score, etc.
class Partition
  attr_reader :name, :default_locale, :host, :max_cost, :analytics_key
  attr_reader :api_settings

  # Creates a new Partition, using the given options (from the config file).
  #
  # @param [Hash] attributes
  #   The attributes to be used to create the Partition.
  #
  # @raise [KeyError]
  #   Raises KeyError if the attributes are missing one or more requires keys.
  #
  def initialize(attributes)
    attributes      = attributes.symbolize_keys

    @name           = attributes.fetch(:app_name)
    @host           = attributes.fetch(:hostname)
    @max_cost       = attributes.fetch(:max_total_cost)
    @api_settings   = attributes.fetch(:api_session_settings).freeze

    @default_locale = attributes.fetch(:default_locale, 'nl')
    @multi_language = attributes.fetch(:multilanguage, true)
    @show_score     = attributes.fetch(:score, true)
    @analytics_key  = attributes.fetch(:google_analytics_key, nil)

    freeze
  end

  # @return [true, false]
  #   Returns if the user is allowed to change the language of the UI.
  #
  def multi_language?
    @multi_language
  end

  # @return [true, false]
  #   Returns if Gooogle Analytics should be enabled.
  #
  def analytics?
    @analytics_key.present?
  end

  # @return [true, false]
  #   Returns if a scenario score be shown to the user.
  #
  def show_score?
    @show_score
  end
end # Partition
