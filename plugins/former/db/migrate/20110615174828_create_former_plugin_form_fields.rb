class CreateFormerPluginFormFields < ActiveRecord::Migration
  def self.up
    create_table :former_plugin_form_fields do |t|
      t.string :entity_type
      t.string :identifier
      t.string :name

      t.timestamps
    end

    add_index :former_plugin_form_fields, :entity_type
    add_index :former_plugin_form_fields, :identifier
  end

  def self.down
    drop_table :former_plugin_form_fields
  end
end
