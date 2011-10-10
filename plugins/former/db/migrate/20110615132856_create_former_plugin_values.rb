class CreateFormerPluginValues < ActiveRecord::Migration
  def self.up
    create_table :former_plugin_values do |t|
      t.integer :field_id
      t.integer :instance_id
      t.integer :option_id
      t.text :value

      t.timestamps
    end
  end

  def self.down
    drop_table :former_plugin_values
  end
end
