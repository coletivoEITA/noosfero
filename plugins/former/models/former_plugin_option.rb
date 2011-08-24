class FormerPluginOption < ActiveRecord::Base
  belongs_to :field, :class_name => 'FormerPluginField'
end
