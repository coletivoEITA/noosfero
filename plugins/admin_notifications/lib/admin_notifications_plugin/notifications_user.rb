class AdminNotificationsPlugin::NotificationsUser < ApplicationRecord
  self.table_name = "admin_notifications_plugin_notifications_users"

  belongs_to :user
  belongs_to :notification, class_name: 'AdminNotificationsPlugin::Notification'

  validates_uniqueness_of :user_id, :scope => :notification_id
end
