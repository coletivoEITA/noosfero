class CommentClassificationPlugin::Status < ApplicationRecord

  belongs_to :owner, :polymorphic => true

  validates_presence_of :name

  scope :enabled, -> { where enabled: true }

end
