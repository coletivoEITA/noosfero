require 'noosfero/plugin'
require 'noosfero/plugin/manager'
require 'noosfero/plugin/context'
require 'noosfero/plugin/active_record'
require 'noosfero/plugin/mailer_base'
Rails.configuration.to_prepare do
  Noosfero::Plugin.init_system
end

