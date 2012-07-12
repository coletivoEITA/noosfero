class ProfileBlock < Block

  def self.description
    _('Show your social badge')
  end

  def help
    _('Show your social badge')
  end

  def content(args={})
    block = self
    lambda do
      if block.box.main?
        load_profile_badge
        render :file => 'profile/badge'
      else
        ''
      end
    end
  end

end
