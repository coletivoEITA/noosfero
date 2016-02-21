class VolunteersPlugin::Assignment < ApplicationRecord

  belongs_to :profile
  belongs_to :period, class_name: 'VolunteersPlugin::Period'

  validates_presence_of :profile
  validates_presence_of :period
  validates_uniqueness_of :profile_id, scope: :period_id

end
