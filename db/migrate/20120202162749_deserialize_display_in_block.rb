class DeserializeDisplayInBlock < ActiveRecord::Migration
  def self.up
    add_column :blocks, :display, :string, :default => 'always'
    add_index :blocks, :display

    Block.all.each do |block|
      block.display = block.settings.delete :display
      block.save!
    end
  end

  def self.down
    say "this migration can't be reverted"
  end
end
