class MessagingPlugin::Message < Noosfero::Plugin::ActiveRecord

  establish_connection MessagingPlugin.db_connection_name

  has_many :conversation_messages, :class_name => 'MessagingPlugin::ConversationMessage', :foreign_key => :message_id
  has_many :conversations, :through => :conversation_messages

  has_many :message_addresses, :class_name => 'MessagingPlugin::MessageAddress', :foreign_key => :message_id
  has_many :addresses, :through => :message_addresses

  validates_uniqueness_of :identifier

  def human_date
    if self.date.today?
      self.date.strftime "%I:%M %p"
    else
      "#{I18n.t('date.abbr_month_names')[self.date.month]} #{self.date.day}"
    end
  end

  protected

end
