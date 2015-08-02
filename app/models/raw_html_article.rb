class RawHTMLArticle < TextArticle

  def self.type_name
    _('HTML')
  end

  def self.short_description
    _('Raw HTML text article')
  end

  def self.description
    _('Allows HTML without filter (only for admins).')
  end

  def body
    self[:body].html_safe
  end

end
