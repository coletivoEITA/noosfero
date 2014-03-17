class CreateMessagingPluginMessageAddresses < ActiveRecord::Migration
  def self.connection
    MessagingPlugin::MessageAddress.connection
  end

  def self.up
    create_table :messaging_plugin_message_addresses do |t|
      t.integer :message_id
      t.integeger :address_id

      t.timestamps
    end
  end

  def self.down
    drop_table :messaging_plugin_message_addresses
  end
end
