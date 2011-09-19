class FormerPluginOption < ActiveRecord::Base
  belongs_to :field, :class_name => 'FormerPluginField'

  validates_presence_of :field
end
