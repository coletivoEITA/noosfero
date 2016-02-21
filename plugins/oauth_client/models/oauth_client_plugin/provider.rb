class OauthClientPlugin::Provider < ApplicationRecord

  belongs_to :environment

  validates_presence_of :name, :strategy

  extend ActsAsHavingImage::ClassMethods
  acts_as_having_image

  extend ActsAsHavingSettings::ClassMethods
  acts_as_having_settings field: :options

  settings_items :site, type: String
  settings_items :client_options, type: Hash

  scope :enabled, -> { where enabled: true }

end
