class CreateFormerPluginOptions < ActiveRecord::Migration
  def self.up
    create_table :former_plugin_options do |t|
      t.integer :field_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :former_plugin_options
  end
end
