class CmsLearningPlugin::LearningsBlock < Block

  def self.description
    _("Profile's Learnigs")
  end

  def self.short_description
    _("Profile's Learnigs")
  end

  def default_title
    _('Learnings')
  end

  def help
    _("This block show learnings of your profile")
  end

  def content
    block = self
    lambda do
      render :file => 'blocks/cms_learning_plugin/learnings_block', :locals => {:block => block}
    end
  end

end

