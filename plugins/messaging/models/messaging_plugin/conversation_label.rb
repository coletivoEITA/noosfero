class MessagingPlugin::ConversationLabel < Noosfero::Plugin::ActiveRecord

  establish_connection MessagingPlugin.db_connection_name

  belongs_to :conversation, :class_name => 'MessagingPlugin::Conversation'
  belongs_to :label, :class_name => 'MessagingPlugin::Label'


end
