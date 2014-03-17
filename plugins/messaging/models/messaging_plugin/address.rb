class MessagingPlugin::Address < Noosfero::Plugin::ActiveRecord

  establish_connection MessagingPlugin.db_connection_name

  validates_presence_of :identifier

end
