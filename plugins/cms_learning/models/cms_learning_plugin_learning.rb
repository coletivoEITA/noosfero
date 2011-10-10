class CmsLearningPluginLearning < Article

  def self.short_description
    _('Learning')
  end

  def self.description
      _('Share learnings to the network.')
  end

  def self.icon_name(article = nil)
    'learning'
  end

  def name
    _('Learning')
  end

  def to_html(options = {})
    lambda do
      @controller.append_view_path CmsLearningPlugin.view_path
      render :file => 'cms/cms_learning_plugin_page'
    end
  end

  def default_parent
    profile.articles.find_by_name _('Learnings'), :conditions => {:type => 'Folder'}
  end

  settings_items :summary, :type => :string, :default => ""
  settings_items :good_practices, :type => :string, :default => ""

  def use_media_panel?
    true
  end

  def tiny_mce?
    true
  end

end
