class MigrateHomepageToBlocks < ActiveRecord::Migration
  def self.up
    Profile.all.each do |profile|
      home_page = Article.find_by_id profile.attributes['home_page_id']
      if home_page
        b = ArticleBlock.new
        b.article = home_page
      else
        b = ProfileBlock.new
      end

      main_box = profile.boxes.find_by_position 1
      b.box = main_box
      b.save!
      main_box.reload
    end
  end

  def self.down
  end
end
