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

  def content
    block = self
    lambda do
      sniffer = SnifferPluginProfile.find_by_profile_id(block.owner)
      interests = sniffer.opportunities
      render :file => 'blocks/sniffer_plugin/interests_block',
        :locals => {:block => block, :interests => interests}
    end
  end

end

