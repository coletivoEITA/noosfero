class AddSettingsToFormerPluginFormField < ActiveRecord::Migration
  def self.up
    add_column :former_plugin_form_fields, :settings, :text
  end

  def self.down
    remove_column :former_plugin_form_fields, :settings
  end
end
