class MigrateHomepageToBlocks < ActiveRecord::Migration
  def self.up
    Profile.all.each do |profile|
      if profile.home_page
        b = ArticleBlock.new
        b.settings[:article_id] = profile.home_page.id
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
