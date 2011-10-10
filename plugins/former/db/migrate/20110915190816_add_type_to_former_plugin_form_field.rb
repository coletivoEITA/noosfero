class AddTypeToFormerPluginFormField < ActiveRecord::Migration
  def self.up
    add_column :former_plugin_form_fields, :type, :string
  end

  def self.down
    remove_column :former_plugin_form_fields, :type
  end
end
