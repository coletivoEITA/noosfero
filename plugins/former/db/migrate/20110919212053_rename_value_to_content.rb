class RenameValueToContent < ActiveRecord::Migration
  def self.up
    rename_column :former_plugin_values, :value, :content
  end

  def self.down
    rename_column :former_plugin_values, :content, :value
  end
end
