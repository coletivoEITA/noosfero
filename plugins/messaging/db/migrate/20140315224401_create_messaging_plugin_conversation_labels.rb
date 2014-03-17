class CreateMessagingPluginConversationLabels < ActiveRecord::Migration
  def self.connection
    MessagingPlugin::ConversationLabel.connection
  end

  def self.up
    create_table :messaging_plugin_conversation_labels do |t|
      t.integer :conversation_id
      t.integer :label_id

      t.timestamps
    end
  end

  def self.down
    drop_table :messaging_plugin_conversation_labels
  end
end
