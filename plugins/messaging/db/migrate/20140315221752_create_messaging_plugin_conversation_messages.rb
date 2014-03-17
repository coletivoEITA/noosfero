class CreateMessagingPluginConversationMessages < ActiveRecord::Migration
  def self.connection
    MessagingPlugin::ConversationMessage.connection
  end

  def self.up
    create_table :messaging_plugin_conversation_messages do |t|
      t.integer :conversation_id
      t.integer :message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :messaging_plugin_conversation_messages
  end
end
