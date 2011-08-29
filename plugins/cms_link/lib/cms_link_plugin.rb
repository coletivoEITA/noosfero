class CmsLinkPlugin < Noosfero::Plugin

  def stylesheet?
     true
  end
  
  def self.plugin_name
    "CmsLink"
  end

  def self.plugin_description
    _("Add a cms link content.")
  end
 
  def self.view_path
    (RAILS_ROOT + '/plugins/cms_link/views')
  end

  def article_types
     {
      :name => CmsLinkPluginLink.type_name,
      :short_description => CmsLinkPluginLink.short_description,
      :description => CmsLinkPluginLink.description,
      :type => CmsLinkPluginLink,
      :view_path => CmsLinkPlugin.view_path
     }
  end

end
