class Thumbnail < ApplicationRecord

  has_attachment :storage => :file_system,
    :content_type => :image, :max_size => UploadedFile.max_size, processor: 'Rmagick'
  validates_as_attachment

  sanitize_filename

  postgresql_attachment_fu

end
