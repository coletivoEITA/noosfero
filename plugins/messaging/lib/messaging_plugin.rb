require_dependency "#{File.dirname __FILE__}/ext/profile"

class MessagingPlugin < Noosfero::Plugin

  def self.plugin_name
    I18n.t('messaging_plugin.lib.plugin.name')
  end

  def self.plugin_description
    I18n.t('messaging_plugin.lib.plugin.description')
  end

  def self.db_connection_name
    "messaging_#{Rails.env}"
  end

  def stylesheet?
    true
  end

  def js_files
    ['messaging'].map{ |j| "javascripts/#{j}" }
  end

end
