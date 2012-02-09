class AddPercentageWidthToBlock < ActiveRecord::Migration
  def self.up
    add_column :blocks, :percentage_width, :string, :default => '100'
  end

  def self.down
    remove_column :blocks, :percentage_width
  end
end
