class AddRequiredToFormerPluginFields < ActiveRecord::Migration
  def self.up
    add_column :former_plugin_fields, :required, :boolean
  end

  def self.down
    remove_column :former_plugin_fields, :required
  end
end
