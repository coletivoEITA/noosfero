class ExchangePlugin < Noosfero::Plugin
  require_dependency 'ext/product'

  def self.plugin_name
    "ExchangePlugin"
  end

  def self.plugin_description
    _("A plugin that implement an exchange system inside noosfero.")
  end

  def control_panel_buttons
    if context.profile.enterprise?
      { :title => 'My Exchanges', :icon => 'exchange', :url => {:controller => 'exchange_plugin_myprofile', :action => 'index'} }
    end
  end

  def stylesheet?
    true
  end


end
