class RemoveHomepageFromProfile < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :home_page_id
  end

  def self.down
    say "this migration can't be reverted"
  end
end
