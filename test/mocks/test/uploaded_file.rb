require "#{Rails.root}/app/models/uploaded_file.rb"

class UploadedFile < Article

  has_attachment(attachment_options.merge(:path_prefix => "test/tmp"))

end
