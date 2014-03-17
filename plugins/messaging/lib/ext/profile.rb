require_dependency 'profile'

class Profile

  has_many :conversations, :class_name => 'MessagingPlugin::Conversation'

end
