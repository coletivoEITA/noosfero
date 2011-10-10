class AddIdentifierToFormerPluginField < ActiveRecord::Migration
  def self.up
    add_column :former_plugin_fields, :identifier, :string
    remove_column :former_plugin_fields, :display_name
  end

  def self.down
    remove_column :former_plugin_fields, :identifier
  end
end
