class CmsLearningPlugin < Noosfero::Plugin

  def self.plugin_name
    "CmsLearning"
  end

  def self.plugin_description
    _("Share your knowledge to the network.")
  end
 
  def self.view_path
    (RAILS_ROOT + '/plugins/cms_learning/views')
  end

  def article_types
     {
      :name => CmsLearningPluginLearning.name,
      :short_description => CmsLearningPluginLearning.short_description,
      :description => CmsLearningPluginLearning.description,
      :type => CmsLearningPluginLearning,
      :view_path => CmsLearningPlugin.view_path
     }
  end

end
