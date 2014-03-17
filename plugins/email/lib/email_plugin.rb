require_dependency "#{File.dirname __FILE__}/ext/profile"

class EmailPlugin < Noosfero::Plugin

  def self.plugin_name
    I18n.t('email_plugin.lib.plugin.name')
  end

  def self.plugin_description
    I18n.t('email_plugin.lib.plugin.description')
  end

  def stylesheet?
    true
  end

  def js_files
    ['underscore-min', 'email'].map{ |j| "javascripts/#{j}" }
  end

end
