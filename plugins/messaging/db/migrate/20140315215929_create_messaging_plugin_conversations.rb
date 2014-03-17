class CreateMessagingPluginConversations < ActiveRecord::Migration
  def self.connection
    MessagingPlugin::Conversation.connection
  end

  def self.up
    create_table :messaging_plugin_conversations do |t|
      t.string :type
      t.integer :profile_id
      t.integer :owner_id
      t.string :owner_type

      t.text :title
      t.datetime :last_date
      t.datetime :read_at

      t.timestamps
    end
  end

  def self.down
    drop_table :messaging_plugin_conversations
  end
end
