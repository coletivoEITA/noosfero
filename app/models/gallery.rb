class Gallery < Folder

  def self.type_name
    _('Gallery')
  end

  def self.short_description
    _('Gallery')
  end

  def self.description
    _('A gallery, inside which you can put images.')
  end

  def to_html(options={})
    lambda do
      render :file => 'content_viewer/image_gallery'
    end
  end

  def gallery?
    true
  end

  def self.icon_name(article = nil)
    'gallery'
  end

end
