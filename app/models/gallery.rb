class Gallery < Folder

  def self.short_description
    _('Gallery')
  end

  def self.description
    _('A gallery, inside which you can put images.')
  end

  include ActionView::Helpers::TagHelper
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
