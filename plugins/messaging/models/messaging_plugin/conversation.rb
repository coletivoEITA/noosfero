class MessagingPlugin::Conversation < Noosfero::Plugin::ActiveRecord

  establish_connection MessagingPlugin.db_connection_name

  belongs_to :profile
  belongs_to :owner, :polymorphic => true

  has_many :conversation_messages, :class_name => 'MessagingPlugin::ConversationMessage', :foreign_key => :conversation_id, :dependent => :destroy
  has_many :messages, :through => :conversation_messages, :order => 'date ASC'

  has_many :conversation_labels, :class_name => 'MessagingPlugin::ConversationMessage', :foreign_key => :message_id, :dependent => :destroy
  has_many :labels, :through => :conversation_messages

  validates_presence_of :profile
  validates_presence_of :owner

  named_scope :profile, lambda{ |id| {:conditions => {:profile_id => id}} }

  def last_message
    self.messages.last
  end

  def date
    self.last_message.human_date
  end

  def from
    self.messages.collect &:from
  end

  protected

end

