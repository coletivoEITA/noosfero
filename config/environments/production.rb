require_relative '../initializers/01_load_config'

Noosfero::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching             = true
  config.action_view.cache_template_loading            = true

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host                  = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  config.cache_store = :mem_cache_store, "localhost"

  config.middleware.insert_before ActionDispatch::Session::CookieStore, NoosferoHttpCaching::Middleware

  if NOOSFERO_CONF['production'] and NOOSFERO_CONF['production']['exception_recipients']
    config.middleware.use ExceptionNotifier,
      :email_prefix => "[Exception] ",
      :sender_address => %{"Exception Notifier" <support@example.com>},
      :exception_recipients => NOOSFERO_CONF['production']['exception_recipients']
  end
end
