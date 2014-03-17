require_dependency 'profile'

class Profile

  has_many :email_accounts, :class_name => 'EmailPlugin::Account'

  has_many :email_conversations, :class_name => 'EmailPlugin::Conversation'

  has_many :email_messages, :through => :email_conversations, :source => :messages

end
