class MessagingPlugin::ConversationMessage < Noosfero::Plugin::ActiveRecord

  establish_connection MessagingPlugin.db_connection_name

  belongs_to :conversation, :class_name => 'MessagingPlugin::Conversation'
  belongs_to :message, :class_name => 'MessagingPlugin::Message'

end
