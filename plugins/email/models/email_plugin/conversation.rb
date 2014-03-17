class EmailPlugin::Conversation < MessagingPlugin::Conversation

  set_table_name :messaging_plugin_conversations

  # overhide to change class name
  has_many :messages, :through => :conversation_messages, :class_name => 'EmailPlugin::Message'

end
