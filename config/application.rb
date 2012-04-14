require File.expand_path('../boot', __FILE__)
require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

def noosfero_session_secret
  require 'fileutils'
  target_dir = File.join(File.dirname(__FILE__), '/../tmp')
  FileUtils.mkdir_p(target_dir)
  file = File.join(target_dir, 'session.secret')
  if !File.exists?(file)
    secret = (1..128).map { %w[0 1 2 3 4 5 6 7 8 9 a b c d e f][rand(16)] }.join('')
    File.open(file, 'w') do |f|
      f.puts secret
    end
  end
  File.read(file).strip
end

module Noosfero
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W( #{Rails.root}/app/sweepers #{Rails.root}/lib )
    config.paths["app/controllers"] = %w[app/controllers/my_profile app/controllers/admin app/controllers/system app/controllers/public]
    config.paths["app/controllers"].each{ |p| ActiveSupport::Dependencies.autoload_paths << p }

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Enable the asset pipeline
    config.assets.enabled = false

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # don't load the sweepers while loading the database
    ignore_rake_commands = %w[
    db:schema:load
    gems:install
    clobber
    noosfero:translations:compile
    makemo
    ]
    if $PROGRAM_NAME =~ /rake$/ && (ignore_rake_commands.include?(ARGV.first))
      $NOOSFERO_LOAD_PLUGINS = false
    else
      $NOOSFERO_LOAD_PLUGINS = true
      config.active_record.observers = :article_sweeper, :role_assignment_sweeper, :friendship_sweeper, :category_sweeper, :block_sweeper
    end
    # Make Active Record use UTC-base instead of local time
    # config.active_record.default_timezone = :utc

    # Your secret key for verifying cookie session data integrity.
    # If you change this key, all old sessions will become invalid!
    # Make sure the secret is at least 30 characters and all random, 
    # no regular words or you'll be exposed to dictionary attacks.
    config.session_store :cookie_store, :key => '_noosfero_session'
    config.secret_token = noosfero_session_secret()

    # Adds custom attributes to the Set of allowed html attributes for the #sanitize helper
    config.action_view.sanitized_allowed_attributes = 'align', 'border', 'alt', 'vspace', 'hspace', 'width', 'heigth', 'value', 'type', 'data', 'style', 'target', 'codebase', 'archive', 'classid', 'code', 'flashvars', 'scrolling', 'frameborder'

    # Adds custom tags to the Set of allowed html tags for the #sanitize helper
    config.action_view.sanitized_allowed_tags = 'object', 'embed', 'param', 'table', 'tr', 'th', 'td', 'applet', 'comment', 'iframe'
  end
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below

ActiveRecord::Base.store_full_sti_class = true

# several local libraries
require 'noosfero'
#require 'sqlite_extension'

# if you want to override this, do it in config/local.rb !
Noosfero.default_locale = nil

# load a local configuration if present, but not under test environment.
if !['test', 'cucumber'].include?(ENV['RAILS_ENV'])
  localconfigfile = File.join(Rails.root, 'config', 'local.rb')
  if File.exists?(localconfigfile)
    require localconfigfile
  end
end
