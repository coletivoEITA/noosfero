class CmsLinkPluginLink < Article

  validates_presence_of :external_link

  def self.short_description
    _('Link')
  end

  def self.description
      _('A link, availability inside which you can put link for any web sites references.')
  end

  def folder?
    false
  end

  def link?
    true
  end

  def self.icon_name(article = nil)
    'link'
  end

  def self.type_name
    _('Link')
  end

  def to_html(options = {})
    lambda do
      @controller.append_view_path CmsLinkPlugin.view_path
      render :file => 'cms/cms_link_plugin_page'
    end
  end

end