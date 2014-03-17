class MessagingPlugin::Label < Noosfero::Plugin::ActiveRecord

  establish_connection MessagingPlugin.db_connection_name

  belongs_to :profile

  validates_presence_of :name

end
