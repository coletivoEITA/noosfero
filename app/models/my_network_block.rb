class MyNetworkBlock < Block

  def self.description
    _('My network')
  end

  def default_title
    _('My network')
  end

  def help
    _('This block displays some info about your networking.')
  end

  def cacheable?
    false
  end

end
