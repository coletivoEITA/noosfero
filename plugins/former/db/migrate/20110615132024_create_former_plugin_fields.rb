class CreateFormerPluginFields < ActiveRecord::Migration
  def self.up
    create_table :former_plugin_fields do |t|
      t.integer :form_field_id
      t.string :type
      t.string :name
      t.string :display_name

      t.timestamps
    end
  end

  def self.down
    drop_table :former_plugin_fields
  end
end
