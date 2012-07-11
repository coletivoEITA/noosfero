class SnifferPlugin::InterestsBlock < Block

  def self.description
    _("Profile's interests")
  end

  def self.short_description
    _("Profile's interests")
  end

  def default_title
    _('Interests')
  end

  def help
    _("This block show interests of your profile")
  end

  def content(args = {})
    block = self
    lambda do
      sniffer = SnifferPluginProfile.find_or_create(block.owner)
      interests = sniffer.opportunities
      inputs = sniffer.profile.enterprise? ? sniffer.profile.inputs : nil
      render :file => 'blocks/sniffer_plugin/interests_block',
        :locals => {:block => block, :interests => interests, :inputs => inputs}
    end
  end

end

