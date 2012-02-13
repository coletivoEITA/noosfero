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

  def stylesheet?
    true
  end

  def js_files
    []
  end

  def profile_blocks(profile)
    CmsLearningPlugin::LearningsBlock
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

  def search_controller_filter
    [{
      :type => 'before_filter',
      :method_name => 'append_view_path',
      :options => {},
      :block => lambda { @controller.append_view_path CmsLearningPlugin.view_path }
    }]
  end

end
