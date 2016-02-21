class PushNotificationPlugin::NotificationSubscription < ApplicationRecord

  belongs_to :environment

  validates :notification, :uniqueness => true
  serialize :subscribers

end

