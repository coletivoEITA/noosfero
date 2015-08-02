#FIXME This after save calls the environment methods 'blocks' and
# 'portal_community'. Both acts as not defined don't know why.
class ArticleSweeper < ActiveRecord::Observer
  def after_save(article)
  end
end

class FixMisunderstoodScriptFilename < ActiveRecord::Migration
  def self.up
    Image.all.select { |i| !i.thumbnail? && File.extname(i.filename) == '.txt'}.map do |image|
      image.thumbnails.destroy_all
      image.filename = fixed_name(image)
      image.save!
      image.create_thumbnails
    end

    UploadedFile.all.select { |u| u.image? && File.extname(u.filename) == '.txt' }.map do |uploaded_file|
      uploaded_file.thumbnails.destroy_all
      uploaded_file.filename = fixed_name(uploaded_file)
      uploaded_file.save!
      uploaded_file.create_thumbnails
    end

    Thumbnail.all.select { |u| u.image? && File.extname(u.filename) == '.txt' }.map do |thumbnail|
      thumbnail.filename = fixed_name(thumbnail)
      thumbnail.save!
    end

  end

  def self.down
    say "WARNING: cannot undo this migration"
  end

  class << self
    def fixed_name(file)
      file.filename.gsub('.txt', '')
    end
  end

end
