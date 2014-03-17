class CreateMessagingPluginAddresses < ActiveRecord::Migration
  def self.connection
    MessagingPlugin::Address.connection
  end

  def self.up
    create_table :messaging_plugin_addresses do |t|
      t.string :type

      t.string :identifier
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :messaging_plugin_addresses
  end
end
