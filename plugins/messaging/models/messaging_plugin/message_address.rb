class MessagingPlugin::MessageAddress < Noosfero::Plugin::ActiveRecord

  establish_connection MessagingPlugin.db_connection_name

  belongs_to :message, :class_name => 'MessagingPlugin::Message'
  belongs_to :address, :class_name => 'MessagingPlugin::Address'

end
