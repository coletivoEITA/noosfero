class ProfileImageBlock < Block

  settings_items :show_name, :type => :boolean, :default => false

  def self.description
    _('Profile Image')
  end

  def help
    _('This block presents the profile image')
  end

  def cacheable?
    false
  end

end
