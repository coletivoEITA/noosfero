config.cache_classes = true
config.action_controller.perform_caching = true

config.action_controller.consider_all_requests_local = false
config.action_view.cache_template_loading            = true

config.whiny_nils = true
config.log_level = :debug

# First disable fiveruns_tuneup at environment.rb
config.gem 'newrelic_rpm'

#config.gem 'rack-bug', :lib => 'rack/bug'
#config.middleware.use "Rack::Bug", :secret_key => "secret"

