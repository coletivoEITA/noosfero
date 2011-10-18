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

  def self.form
    @form ||= FormerPluginFormField.find_or_create :learning_fields, CmsLearningPluginLearning.to_s, {:name => _('CMS Learning form')}
  end

  def self.learning_field
    f = form.fields.first
    if f.nil? 
      f = FormerPluginOptionField.create! :form => form, :name => _('Kind'), :identifier => 'kind'
      f.options = [_('Learning 1'), _('Learning 2'), _('Learning 3')].map do |name|
        FormerPluginOption.create! :field_id => f.id, :name => name
      end
    end
    fields = [f] #only this field!
    f
  end

  def stylesheet?
    true
  end

  def js_files
    []
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
