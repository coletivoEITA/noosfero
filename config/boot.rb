# Don't change this file!
# Configure your app in config/environment.rb and config/environments/*.rb

RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

require 'yaml'
YAML::ENGINE.yamler = 'syck'

