class CreateMessagingPluginLabels < ActiveRecord::Migration
  def self.connection
    MessagingPlugin::Label.connection
  end

  def self.up
    create_table :messaging_plugin_labels do |t|
      t.string :type
      t.integer :profile_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :messaging_plugin_labels
  end
end
